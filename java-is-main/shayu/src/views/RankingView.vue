<script setup>
import { ref, onMounted } from 'vue'

const API = ''
const toastMsg = ref('')
let toastTimer = null
function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}

function authHeaders() {
  let token = ''
  try { token = localStorage.getItem('shark_token') || '' } catch (e) {}
  return { Authorization: 'Bearer ' + token }
}

const ranking = ref([])
const loading = ref(false)

/* 当前用户 id 与已关注集合：用于排行榜上的关注按钮初始状态 */
const myId = ref(null)
const followedSet = ref(new Set())
const followBusy = ref(false)

async function loadRanking() {
  loading.value = true
  try {
    const res = await fetch(API + '/api/profile/ranking', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    ranking.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    ranking.value = []
  } finally {
    loading.value = false
  }
}

/* 加载当前用户资料（拿 id）+ 已关注列表（拿关注状态） */
async function loadMeta() {
  try {
    const res = await fetch(API + '/api/profile', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok && d.data) myId.value = d.data.id || null
  } catch (e) { /* 静默 */ }
  try {
    const res = await fetch(API + '/api/profile/following', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok && Array.isArray(d.data)) followedSet.value = new Set(d.data.map(u => u.id))
  } catch (e) { /* 静默 */ }
}

function isFollowing(u) { return followedSet.value.has(u.userId) }
function isSelf(u) { return u.userId != null && u.userId === myId.value }

async function toggleFollow(u) {
  if (followBusy.value || isSelf(u)) return
  const nowFollow = !followedSet.value.has(u.userId)
  // 乐观更新
  const next = new Set(followedSet.value)
  if (nowFollow) next.add(u.userId); else next.delete(u.userId)
  followedSet.value = next
  followBusy.value = true
  try {
    const path = nowFollow ? '/api/profile/follow' : '/api/profile/unfollow'
    const res = await fetch(API + path + '?targetId=' + u.userId, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (!res.ok) {
      // 失败回滚
      const rev = new Set(followedSet.value)
      if (nowFollow) rev.delete(u.userId); else rev.add(u.userId)
      followedSet.value = rev
      toast(d.message || '操作失败')
    } else {
      toast(d.message || (nowFollow ? '已关注 ✅' : '已取消关注'))
    }
  } catch (e) {
    const rev = new Set(followedSet.value)
    if (nowFollow) rev.delete(u.userId); else rev.add(u.userId)
    followedSet.value = rev
    toast('网络错误，请稍后重试 🔌')
  } finally {
    followBusy.value = false
  }
}

/* 进他人主页浏览 */
function goUser(u) { location.hash = '#/user/' + u.userId }

onMounted(() => { loadRanking(); loadMeta() })

function fmtDuration(sec) {
  const v = Math.floor(Number(sec) || 0)
  if (v < 60) return v + ' 秒'
  if (v < 3600) return Math.floor(v / 60) + ' 分 ' + (v % 60) + ' 秒'
  return Math.floor(v / 3600) + ' 小时 ' + Math.floor((v % 3600) / 60) + ' 分'
}

function fmtPlays(n) {
  const v = Number(n) || 0
  if (v >= 10000) return (v / 10000).toFixed(1).replace(/\.0$/, '') + '万'
  return String(v)
}

/* 前三名专属奖杯 */
function medal(rank) {
  return rank === 1 ? '🥇' : rank === 2 ? '🥈' : rank === 3 ? '🥉' : ''
}

function goHome() { location.hash = '#/home' }
</script>

<template>
  <main class="rk-shell">
    <header class="rk-hero">
      <div class="rk-hero-deco a"></div>
      <div class="rk-hero-deco b"></div>
      <a class="rk-back" href="#" @click.prevent="goHome">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回首页
      </a>
      <div class="rk-hero-text">
        <em>LISTENING LEADERBOARD</em>
        <h2>听歌总排名榜</h2>
        <p>统计所有鲨鲨的累计听歌时长，看看谁是真正的「鲨鱼之神」🏆</p>
      </div>
      <div class="rk-hero-stats">
        <div><b>{{ ranking.length }}</b><span>位听众</span></div>
      </div>
    </header>

    <div class="rk-body">
      <div v-if="loading" class="rk-loading">加载中…</div>
      <template v-else>
        <!-- 前三名领奖台 -->
        <div v-if="ranking.length" class="rk-podium">
          <div
            v-for="u in ranking.slice(0, 3)"
            :key="u.userId"
            class="rk-podium-item"
            :class="'p' + u.rank"
          >
            <div class="rk-podium-medal">{{ medal(u.rank) }}</div>
            <span class="rk-podium-ava" @click="goUser(u)" style="cursor:pointer">{{ u.avatarLetter }}</span>
            <b class="rk-podium-name" @click="goUser(u)" style="cursor:pointer">{{ u.nickname }}</b>
            <span class="rk-podium-dur">{{ fmtDuration(u.listenSeconds) }}</span>
            <span class="rk-podium-level">Lv.{{ u.level }} {{ u.levelName }}</span>
            <div class="rk-podium-actions">
              <button
                v-if="!isSelf(u)"
                class="rk-btn"
                :class="{ on: isFollowing(u) }"
                type="button"
                :disabled="followBusy"
                @click="toggleFollow(u)"
              >{{ isFollowing(u) ? '✓ 已关注' : '＋ 关注' }}</button>
              <button class="rk-btn ghost" type="button" @click="goUser(u)">进主页 ›</button>
            </div>
          </div>
        </div>

        <!-- 完整排行榜 -->
        <div v-if="ranking.length" class="rk-list">
          <div v-for="u in ranking" :key="u.userId" class="rk-item" :class="{ top: u.rank <= 3 }">
            <span class="rk-rank" :class="'r' + u.rank">{{ u.rank <= 3 ? medal(u.rank) : u.rank }}</span>
            <span class="rk-ava" @click="goUser(u)" style="cursor:pointer">{{ u.avatarLetter }}</span>
            <div class="rk-info" @click="goUser(u)" style="cursor:pointer">
              <b>{{ u.nickname }}</b>
              <span>Lv.{{ u.level }} · {{ u.levelName }} · 播放 {{ fmtPlays(u.playCount) }} 次</span>
            </div>
            <div class="rk-actions">
              <button
                v-if="!isSelf(u)"
                class="rk-btn"
                :class="{ on: isFollowing(u) }"
                type="button"
                :disabled="followBusy"
                @click.stop="toggleFollow(u)"
              >{{ isFollowing(u) ? '✓' : '＋' }}</button>
              <button class="rk-btn ghost" type="button" @click.stop="goUser(u)">进主页</button>
            </div>
            <span class="rk-dur">{{ fmtDuration(u.listenSeconds) }}</span>
          </div>
        </div>
        <div v-else class="rk-empty">
          <p>还没有人留下听歌记录 🎧 去听几首歌，成为排行榜第一吧！</p>
        </div>
      </template>
    </div>

    <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
  </main>
</template>

<style>
  body:has(.rk-shell) { padding: 0; display: block; background: #f4f8ff; }
  .rk-shell { position: relative; min-height: 100vh; background: #f4f8ff; padding-bottom: 60px; }

  /* ===== 顶部横幅 ===== */
  .rk-hero {
    position: relative;
    height: 220px;
    background: linear-gradient(120deg, #0a1b33 0%, #0b4a9c 55%, #7c3aed 100%);
    color: #fff; overflow: hidden;
    padding: 0 max(34px, calc((100vw - 1200px) / 2));
    display: flex; align-items: center; gap: 30px;
  }
  .rk-hero-deco { position: absolute; border-radius: 50%; background: rgba(255,255,255,0.08); }
  .rk-hero-deco.a { width: 360px; height: 360px; right: -100px; top: -140px; }
  .rk-hero-deco.b { width: 200px; height: 200px; left: -60px; bottom: -120px; background: rgba(255,255,255,0.05); }
  .rk-back {
    position: absolute; top: 22px; left: max(30px, calc((100vw - 1200px) / 2));
    display: inline-flex; align-items: center; gap: 6px;
    color: rgba(255,255,255,0.85); font-size: 13px; font-weight: 700; text-decoration: none; z-index: 2;
  }
  .rk-back svg { width: 18px; height: 18px; }
  .rk-back:hover { color: #fff; }
  .rk-hero-text { position: relative; z-index: 1; }
  .rk-hero-text em { font-style: normal; font-size: 11px; font-weight: 900; letter-spacing: 4px; color: rgba(255,255,255,0.62); }
  .rk-hero-text h2 { font-size: 30px; font-weight: 800; letter-spacing: 2px; margin-top: 6px; }
  .rk-hero-text p { margin-top: 8px; font-size: 13px; color: rgba(255,255,255,0.75); }
  .rk-hero-stats { position: relative; z-index: 1; margin-left: auto; text-align: center; }
  .rk-hero-stats b { display: block; font-size: 30px; font-weight: 800; }
  .rk-hero-stats span { font-size: 12px; color: rgba(255,255,255,0.7); }

  .rk-body { max-width: 900px; margin: 0 auto; padding: 24px 34px; }
  .rk-loading { text-align: center; padding: 60px; color: #8a94a6; font-weight: 600; }

  /* ===== 前三名领奖台 ===== */
  .rk-podium {
    display: flex; align-items: flex-end; justify-content: center; gap: 16px;
    padding: 30px 0;
  }
  .rk-podium-item {
    flex: 1; max-width: 200px;
    display: flex; flex-direction: column; align-items: center; gap: 6px;
    background: #fff; border: 1px solid #e6eefb; border-radius: 16px;
    padding: 22px 14px;
    transition: transform .18s ease;
  }
  .rk-podium-item:hover { transform: translateY(-4px); }
  .rk-podium-item.p1 { order: 2; padding-top: 38px; box-shadow: 0 16px 36px -18px rgba(245,200,106,0.7); border-color: #f5c86a; }
  .rk-podium-item.p2 { order: 1; }
  .rk-podium-item.p3 { order: 3; }
  .rk-podium-medal { font-size: 36px; }
  .rk-podium-ava {
    width: 64px; height: 64px; border-radius: 50%;
    background: linear-gradient(150deg, var(--shark-blue), var(--shark-blue-deep));
    display: grid; place-items: center;
    font-size: 24px; font-weight: 800; color: #fff;
  }
  .rk-podium-item.p1 .rk-podium-ava { background: linear-gradient(150deg, #ffd166, #f59e0b); }
  .rk-podium-name { font-size: 14px; font-weight: 800; color: var(--ink); }
  .rk-podium-dur { font-size: 12.5px; color: #0b7efc; font-weight: 700; }
  .rk-podium-level { font-size: 11px; color: #9aa5b5; font-weight: 600; }

  /* ===== 关注 / 进主页 按钮（前三名 + 列表通用） ===== */
  .rk-podium-actions { display: flex; gap: 8px; margin-top: 10px; }
  .rk-actions { display: flex; align-items: center; gap: 8px; flex: none; }
  .rk-btn {
    font-family: var(--font); font-size: 12px; font-weight: 800; white-space: nowrap;
    color: #fff; background: linear-gradient(140deg, #0b7efc, #0a6ce0);
    border: 1px solid transparent; border-radius: 999px;
    padding: 6px 14px; cursor: pointer;
    box-shadow: 0 4px 12px rgba(11,126,252,.3);
    transition: transform .12s ease, filter .15s ease, background .15s ease, color .15s ease;
  }
  .rk-btn:hover { filter: brightness(1.05); }
  .rk-btn:active { transform: scale(0.95); }
  .rk-btn:disabled { opacity: 0.7; cursor: default; }
  .rk-btn.on { color: #0b7efc; background: #fff; border-color: #0b7efc; box-shadow: none; }
  .rk-btn.ghost {
    color: #0b7efc; background: #eef5ff; border-color: #d6e6ff; box-shadow: none;
  }
  .rk-btn.ghost:hover { background: #e0edff; }

  /* ===== 完整排行列表 ===== */
  .rk-list { display: flex; flex-direction: column; gap: 10px; }
  .rk-item {
    display: flex; align-items: center; gap: 14px;
    background: #fff; border: 1px solid #e6eefb; border-radius: 14px;
    padding: 12px 16px;
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .rk-item:hover { transform: translateY(-2px); box-shadow: 0 10px 22px rgba(11,126,252,0.12); }
  .rk-item.top { border-color: #f5c86a; background: linear-gradient(160deg, #fff, #fffbef); }
  .rk-rank {
    flex: none; width: 34px; text-align: center;
    font-size: 18px; font-weight: 800; color: #9aa5b5;
  }
  .rk-rank.r1, .rk-rank.r2, .rk-rank.r3 { font-size: 20px; }
  .rk-ava {
    flex: none; width: 42px; height: 42px; border-radius: 50%;
    background: linear-gradient(150deg, var(--shark-blue), var(--shark-blue-deep));
    display: grid; place-items: center;
    font-size: 16px; font-weight: 800; color: #fff;
  }
  .rk-info { flex: 1; min-width: 0; }
  .rk-info b { font-size: 14px; font-weight: 800; color: var(--ink); display: block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .rk-info span { font-size: 12px; color: #9aa5b5; }
  .rk-dur { flex: none; font-size: 14px; font-weight: 800; color: #0b7efc; }

  .rk-empty { text-align: center; padding: 70px 20px; color: #8a94a6; }
  .rk-empty p { font-size: 14px; font-weight: 600; }

  @media (max-width: 940px) {
    .rk-hero { height: auto; flex-direction: column; align-items: flex-start; padding: 60px 22px 24px; gap: 16px; }
    .rk-hero-stats { margin-left: 0; }
    .rk-body { padding: 20px; }
  }
</style>
