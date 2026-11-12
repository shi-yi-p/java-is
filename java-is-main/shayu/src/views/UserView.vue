<script setup>
import { ref, computed, onMounted } from 'vue'

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

/* 从 location.hash（#/user/<id>）解析目标用户 id */
function parseUserId() {
  const raw = location.hash.replace(/^#\/?/, '').split('?')[0]
  const seg = raw.split('/')
  const id = seg.length >= 2 ? Number(seg[1]) : NaN
  return Number.isFinite(id) && id > 0 ? id : null
}
const targetId = ref(parseUserId())

const profile = ref(null)
const moments = ref([])
const loading = ref(false)
const followBusy = ref(false)

const avatarLetter = computed(() => {
  const p = profile.value
  if (p && p.avatar && p.avatar.trim()) return p.avatar.trim()
  const name = p ? (p.nickname || p.account || '鲨') : '鲨'
  return name.slice(0, 1)
})
const isMaxLevel = computed(() => (profile.value ? profile.value.level : 1) >= 10)
const levelProgress = computed(() => {
  const p = profile.value
  if (!p) return 0
  if (typeof p.progress === 'number') return Math.min(100, Math.max(0, p.progress))
  return 0
})

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
function momentIcon(type) {
  return { listen: '🎧', favorite: '❤️', create_playlist: '🦈', follow: '➕' }[type] || '🎵'
}

async function loadUser() {
  if (!targetId.value) { toast('无效的用户'); return }
  loading.value = true
  try {
    const res = await fetch(API + '/api/profile/visit?userId=' + targetId.value, { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok && d.data) {
      profile.value = d.data
    } else {
      toast(d.message || '加载失败')
      profile.value = null
    }
  } catch (e) {
    toast('网络错误，请稍后重试 🔌')
  }
  await loadMoments()
  loading.value = false
}

async function loadMoments() {
  if (!targetId.value) return
  try {
    const res = await fetch(API + '/api/profile/visit/moments?userId=' + targetId.value, { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    moments.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    moments.value = []
  }
}

async function toggleFollow() {
  if (!profile.value || followBusy.value) return
  followBusy.value = true
  const p = profile.value
  const path = p.followed ? '/api/profile/unfollow' : '/api/profile/follow'
  try {
    const res = await fetch(API + path + '?targetId=' + p.id, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok) {
      p.followed = !p.followed
      // 重新计算好友关系：已关注且对方也关注我 = 好友
      p.mutualFollow = p.followed && p.mutualFollow
      toast(d.message || (p.followed ? '已关注 ✅' : '已取消关注'))
      loadUser()
    } else {
      toast(d.message || '操作失败')
    }
  } catch (e) {
    toast('网络错误 🔌')
  } finally {
    followBusy.value = false
  }
}

function goRanking() { location.hash = '#/ranking' }
function goHome() { location.hash = '#/home' }

onMounted(loadUser)
</script>

<template>
  <main class="uv-shell">
    <header class="uv-hero">
      <div class="uv-hero-deco a"></div>
      <div class="uv-hero-deco b"></div>

      <a class="uv-back" href="#" @click.prevent="goRanking">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回榜单
      </a>

      <div v-if="loading" class="uv-loading">加载中…</div>

      <div v-else-if="!profile" class="uv-empty">没有找到该用户 🐟</div>

      <div v-else class="uv-hero-main">
        <div class="uv-avatar">
          <span>{{ avatarLetter }}</span>
          <i class="uv-avatar-badge">Lv.{{ profile.level }}</i>
        </div>
        <div class="uv-hero-info">
          <div class="uv-name-row">
            <h1>{{ profile.nickname }}</h1>
            <span class="uv-vip">{{ profile.levelName }}</span>
            <button
              class="uv-follow-btn"
              :class="{ on: profile.followed, friend: profile.mutualFollow }"
              type="button"
              :disabled="followBusy"
              @click="toggleFollow"
            >
              <template v-if="profile.mutualFollow">🤝 互相关注</template>
              <template v-else-if="profile.followed">✓ 已关注</template>
              <template v-else>＋ 关注</template>
            </button>
          </div>
          <p class="uv-account">账号：{{ profile.account }} · UID：{{ profile.uid || '—' }}</p>

          <!-- 鲨鱼等级卡片 -->
          <div class="uv-level-card">
            <div class="uv-level-card-top">
              <span class="uv-level-lv">Lv.{{ profile.level }}</span>
              <span class="uv-level-name">{{ profile.levelName }}</span>
              <span v-if="isMaxLevel" class="uv-level-max">👑 已满级</span>
              <span v-else class="uv-level-next">距下一级还需 {{ fmtDuration(profile.nextLevelSeconds) }}</span>
            </div>
            <div class="uv-level-bar">
              <div class="uv-level-fill" :style="{ width: levelProgress + '%' }"></div>
            </div>
            <div class="uv-level-card-bottom">
              <span>累计听歌 {{ fmtDuration(profile.listenSeconds) }}</span>
              <span class="uv-level-pct">{{ levelProgress }}%</span>
            </div>
          </div>

          <div class="uv-stats">
            <div><b>{{ profile.following }}</b><span>关注</span></div>
            <div><b>{{ profile.followers }}</b><span>粉丝</span></div>
            <div><b>{{ fmtPlays(profile.playCount) }}</b><span>播放</span></div>
            <div><b>{{ profile.favoriteCount }}</b><span>收藏</span></div>
          </div>
        </div>
      </div>
    </header>

    <!-- 动态 -->
    <section v-if="profile" class="uv-body">
      <div class="uv-block">
        <h3 class="uv-block-title">TA 的动态 <em>{{ moments.length }}</em></h3>
        <div v-if="moments.length">
          <div v-for="m in moments" :key="m.id" class="uv-moment">
            <span class="uv-moment-ico">{{ momentIcon(m.type) }}</span>
            <div class="uv-moment-body">
              <p>{{ m.content }}</p>
              <span class="uv-moment-time">{{ m.createTime }}</span>
            </div>
          </div>
        </div>
        <div v-else class="uv-empty slim">TA 还没有动态 🎵</div>
      </div>
    </section>

    <div class="uv-foot">
      <a href="#" class="uv-foot-link" @click.prevent="goRanking">🏆 返回听歌总榜</a>
      <a href="#" class="uv-foot-link" @click.prevent="goHome">🏠 回到首页</a>
    </div>

    <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
  </main>
</template>

<style>
  body:has(.uv-shell) { padding: 0; display: block; background: #f4f8ff; }
  .uv-shell { position: relative; min-height: 100vh; background: #f4f8ff; padding-bottom: 60px; }

  .uv-hero {
    position: relative;
    min-height: 300px;
    background: linear-gradient(120deg, #0a1b33 0%, #0b4a9c 55%, #1287ff 100%);
    color: #fff;
    overflow: hidden;
  }
  .uv-hero-deco { position: absolute; border-radius: 50%; background: rgba(255, 255, 255, 0.08); }
  .uv-hero-deco.a { width: 420px; height: 420px; right: -120px; top: -160px; }
  .uv-hero-deco.b { width: 260px; height: 260px; left: -80px; bottom: -140px; background: rgba(255, 255, 255, 0.06); }

  .uv-back {
    position: absolute; top: 22px; left: max(30px, calc((100vw - 1200px) / 2));
    display: inline-flex; align-items: center; gap: 6px;
    color: rgba(255, 255, 255, 0.85); font-size: 13px; font-weight: 700; text-decoration: none; z-index: 2;
  }
  .uv-back svg { width: 18px; height: 18px; }
  .uv-back:hover { color: #fff; }

  .uv-loading, .uv-empty { max-width: 1200px; margin: 0 auto; padding: 120px 34px; text-align: center; font-size: 15px; font-weight: 700; color: rgba(255,255,255,0.8); }
  .uv-empty.slim { color: #8a94a6; padding: 36px 20px; border: 2px dashed #cfddf0; border-radius: 12px; background: #fff; }

  .uv-hero-main {
    position: relative; z-index: 1;
    max-width: 1200px; margin: 0 auto;
    padding: 66px 34px 28px;
    display: flex; gap: 28px; align-items: flex-start;
  }
  .uv-avatar {
    position: relative; flex: none;
    width: 132px; height: 132px; border-radius: 50%;
    background: linear-gradient(150deg, var(--pink-soft), var(--pink));
    border: 4px solid rgba(255, 255, 255, 0.85);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
    display: grid; place-items: center;
    font-size: 56px; font-weight: 800; color: var(--ink);
  }
  .uv-avatar-badge {
    position: absolute; right: -6px; bottom: 6px;
    font-style: normal; font-size: 12px; font-weight: 900; letter-spacing: .5px;
    color: #2f1c00; background: linear-gradient(140deg, #ffd166, #f5a623);
    border: 2px solid #fff; border-radius: 999px; padding: 3px 10px;
    box-shadow: 0 3px 8px rgba(0,0,0,.3);
  }
  .uv-hero-info { flex: 1; min-width: 0; padding-top: 4px; }
  .uv-name-row { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .uv-name-row h1 { font-size: 30px; font-weight: 800; letter-spacing: 1px; }
  .uv-vip {
    font-size: 11px; font-weight: 900; letter-spacing: 1px;
    color: #2f1c00; background: linear-gradient(140deg, #ffd166, #f5c86a);
    border-radius: 6px; padding: 2px 8px;
  }
  .uv-follow-btn {
    font-family: var(--font); font-size: 13px; font-weight: 800;
    color: #fff; background: linear-gradient(140deg, #0b7efc, #0a6ce0);
    border: 1px solid rgba(255,255,255,0.5); border-radius: 999px;
    padding: 7px 18px; cursor: pointer;
    box-shadow: 0 4px 12px rgba(11,126,252,.35);
    transition: transform .12s ease, filter .15s ease;
  }
  .uv-follow-btn:hover { filter: brightness(1.05); }
  .uv-follow-btn:active { transform: scale(0.96); }
  .uv-follow-btn:disabled { opacity: 0.7; cursor: default; }
  .uv-follow-btn.on {
    color: #0b7efc; background: #fff; border-color: #fff;
  }
  .uv-follow-btn.friend {
    color: #2f7d32; background: #e8f7ec; border-color: #b7e4c0; box-shadow: none;
  }
  .uv-account { margin-top: 6px; font-size: 13px; color: rgba(255, 255, 255, 0.7); }

  .uv-stats { display: flex; gap: 34px; margin-top: 16px; }
  .uv-stats div { text-align: center; }
  .uv-stats b {
    display: block; font-size: 20px; font-weight: 800;
    font-variant-numeric: tabular-nums; line-height: 1.2;
    max-width: 120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .uv-stats span { font-size: 12px; color: rgba(255, 255, 255, 0.68); }

  /* 等级卡片 */
  .uv-level-card {
    margin-top: 14px; max-width: 460px;
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.22);
    border-radius: 14px; padding: 12px 16px; backdrop-filter: blur(6px);
  }
  .uv-level-card-top { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
  .uv-level-lv {
    font-size: 15px; font-weight: 900; line-height: 1;
    color: #2f1c00; background: linear-gradient(140deg, #ffd166, #f5c86a);
    border-radius: 8px; padding: 5px 10px; box-shadow: 0 2px 8px rgba(0,0,0,.25);
  }
  .uv-level-name { font-size: 15px; font-weight: 800; color: #fff; letter-spacing: 1px; }
  .uv-level-max { font-size: 12px; font-weight: 800; color: #ffd166; margin-left: auto; }
  .uv-level-next { font-size: 12px; font-weight: 600; color: rgba(255, 255, 255, 0.78); margin-left: auto; }
  .uv-level-card-bottom {
    display: flex; align-items: center; justify-content: space-between;
    margin-top: 8px; font-size: 12px; font-weight: 600; color: rgba(255, 255, 255, 0.72);
  }
  .uv-level-pct { font-weight: 800; color: #ffd166; font-variant-numeric: tabular-nums; }
  .uv-level-bar { margin-top: 10px; height: 9px; width: 100%; border-radius: 999px; background: rgba(255,255,255,0.18); overflow: hidden; }
  .uv-level-fill { height: 100%; border-radius: 999px; background: linear-gradient(90deg, #67e8f9, #f5c86a); transition: width 0.5s ease; }

  /* 主体 */
  .uv-body { max-width: 1200px; margin: 0 auto; padding: 24px 34px; }
  .uv-block { background: #fff; border: 1px solid #e6eefb; border-radius: 16px; padding: 20px; }
  .uv-block-title { font-size: 16px; font-weight: 800; color: var(--ink); margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }
  .uv-block-title em { font-style: normal; font-size: 12px; font-weight: 700; color: #8a94a6; }

  .uv-moment { display: flex; gap: 14px; padding: 14px 0; border-bottom: 1px solid #f0f4fa; }
  .uv-moment:last-child { border-bottom: 0; }
  .uv-moment-ico { flex: none; width: 44px; height: 44px; border-radius: 12px; background: #eef5ff; display: grid; place-items: center; font-size: 22px; }
  .uv-moment-body p { font-size: 13.5px; color: #2d3748; line-height: 1.6; }
  .uv-moment-time { font-size: 12px; color: #9aa5b5; margin-top: 4px; display: block; }

  .uv-foot { max-width: 1200px; margin: 0 auto; padding: 8px 34px 0; display: flex; gap: 16px; }
  .uv-foot-link { font-size: 13px; font-weight: 700; color: #0b7efc; text-decoration: none; }
  .uv-foot-link:hover { text-decoration: underline; }

  @media (max-width: 940px) {
    .uv-hero { min-height: auto; }
    .uv-hero-main { flex-direction: column; padding: 56px 22px 24px; }
    .uv-avatar { width: 100px; height: 100px; font-size: 44px; }
    .uv-body { padding: 20px; }
  }
</style>
