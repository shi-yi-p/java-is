<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { player, playTrack, isFavorite, toggleFavorite, refreshFavorites } from '../player.js'
import PlayerBar from '../components/PlayerBar.vue'
import NowPlaying from '../components/NowPlaying.vue'

const API = ''

/* 从 location.hash（#/singer/<id>）解析歌手 id */
function parseSingerId() {
  const raw = location.hash.replace(/^#\/?/, '').split('?')[0]
  const seg = raw.split('/')
  const id = seg.length >= 2 ? Number(seg[1]) : NaN
  return Number.isFinite(id) && id > 0 ? id : null
}
const singerId = ref(parseSingerId())

const singer = ref(null)
const songs = ref([])
const loading = ref(true)

const toastMsg = ref('')
let toastTimer = null
function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}

const initial = computed(() => {
  const name = singer.value ? singer.value.name : '鲨'
  return name ? name.slice(0, 1) : '鲨'
})
const totalPlays = computed(() => songs.value.reduce((sum, s) => sum + (Number(s.plays) || 0), 0))

function fmtPlays(n) {
  const v = Number(n) || 0
  if (v >= 10000) return (v / 10000).toFixed(1).replace(/\.0$/, '') + '万'
  return String(v)
}
function fmtTime(sec) {
  const v = Number(sec) || 0
  return Math.floor(v / 60) + ':' + String(v % 60).padStart(2, '0')
}

async function loadSinger() {
  if (!singerId.value) {
    loading.value = false
    return
  }
  loading.value = true
  try {
    const res = await fetch(API + '/api/singer/' + singerId.value)
    const d = await res.json().catch(() => ({}))
    if (res.ok && d.data) {
      singer.value = d.data
      songs.value = Array.isArray(d.data.songs) ? d.data.songs : []
    } else {
      singer.value = null
      songs.value = []
      toast(d.message || '未找到该歌手')
    }
  } catch (e) {
    singer.value = null
    songs.value = []
    toast('网络错误，请稍后重试 🔌')
  }
  loading.value = false
}

function playSong(s) {
  playTrack(s, songs.value)
}
async function favSong(s, e) {
  if (e) e.stopPropagation()
  const msg = await toggleFavorite(s)
  toast(msg)
}

function goHome() { location.hash = '#/home' }

/* 接收播放器组件（收藏/播放模式切换）派发的提示，与首页一致 */
function onSharkToast(e) { toast(e.detail) }

onMounted(() => {
  refreshFavorites()   /* 直接打开/刷新本页时也要加载收藏集合，否则收藏状态显示错误 */
  loadSinger()
  window.addEventListener('shark-toast', onSharkToast)
})
onUnmounted(() => window.removeEventListener('shark-toast', onSharkToast))
</script>

<template>
  <main class="sv-shell">
    <!-- 正在播放（全屏详情），与首页一致 -->
    <NowPlaying v-if="player.open" />
    <template v-else>
    <header class="sv-hero" :class="singer && singer.tone ? 'tone-' + singer.tone : ''">
      <div class="sv-hero-deco a"></div>
      <div class="sv-hero-deco b"></div>

      <a class="sv-back" href="#" @click.prevent="goHome">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回首页
      </a>

      <div v-if="loading" class="sv-loading">加载中…</div>
      <div v-else-if="!singer" class="sv-loading">没有找到该歌手 🐟</div>

      <div v-else class="sv-hero-main">
        <div class="sv-avatar">{{ initial }}</div>
        <div class="sv-hero-info">
          <div class="sv-name-row">
            <h1>{{ singer.name }}</h1>
            <span v-if="singer.tab" class="sv-region">{{ singer.tab }}歌手</span>
          </div>
          <p class="sv-sub">鲨鱼音乐 · 认证音乐人 🎤</p>
          <div class="sv-stats">
            <div><b>{{ fmtPlays(singer.fans) }}</b><span>粉丝</span></div>
            <div><b>{{ songs.length }}</b><span>首作品</span></div>
            <div><b>{{ fmtPlays(totalPlays) }}</b><span>总播放</span></div>
          </div>
        </div>
      </div>
    </header>

    <section v-if="singer" class="sv-body">
      <div class="sv-block">
        <div class="sv-block-head">
          <h3 class="sv-block-title">发布过的歌曲 <em>{{ songs.length }}</em></h3>
          <button
            v-if="songs.length"
            class="sv-play-all"
            type="button"
            @click="playTrack(songs[0], songs)"
          >▶ 播放全部</button>
        </div>

        <div v-if="songs.length" class="sv-song-list">
          <div
            v-for="(s, i) in songs"
            :key="s.id"
            class="sv-song"
            @click="playSong(s)"
          >
            <span class="sv-idx">{{ i + 1 }}</span>
            <span class="sv-song-main">
              <b class="sv-song-title">{{ s.title }}</b>
              <span class="sv-song-sub">{{ s.album || '单曲' }} · {{ fmtTime(s.duration) }}</span>
            </span>
            <span class="sv-plays">🔥 {{ fmtPlays(s.plays) }}</span>
            <button
              class="sv-fav"
              :class="{ on: isFavorite(s) }"
              type="button"
              :title="isFavorite(s) ? '取消收藏' : '收藏'"
              @click="favSong(s, $event)"
            >{{ isFavorite(s) ? '❤' : '♡' }}</button>
          </div>
        </div>
        <div v-else class="sv-empty">
          TA 还没有发布歌曲 🎵<br />
          <small>作品正在筹备中，先去首页听听别的歌吧～</small>
        </div>
      </div>
    </section>

    <div class="sv-foot">
      <a href="#" class="sv-foot-link" @click.prevent="goHome">🏠 回到首页</a>
    </div>
    </template>
  </main>

  <!-- 底部播放条 -->
  <PlayerBar />

  <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
</template>

<style scoped>
  .sv-shell { position: relative; min-height: 100vh; background: #f4f8ff; padding-bottom: 60px; }
  :global(body:has(.sv-shell)) { padding: 0; display: block; background: #f4f8ff; }

  .sv-hero {
    position: relative;
    min-height: 280px;
    background: linear-gradient(120deg, #0a1b33 0%, #0b4a9c 55%, #1287ff 100%);
    color: #fff;
    overflow: hidden;
  }
  .sv-hero.tone-p2 { background: linear-gradient(120deg, #3b1a09 0%, #9a3412 55%, #f97316 100%); }
  .sv-hero.tone-p3 { background: linear-gradient(120deg, #062c33 0%, #0e7490 55%, #22d3ee 100%); }
  .sv-hero.tone-p4 { background: linear-gradient(120deg, #2b0a1c 0%, #9d174d 55%, #ec4899 100%); }
  .sv-hero.tone-p5 { background: linear-gradient(120deg, #2b1a05 0%, #92400e 55%, #f59e0b 100%); }
  .sv-hero.tone-p6 { background: linear-gradient(120deg, #2b0a0a 0%, #991b1b 55%, #ef4444 100%); }
  .sv-hero.tone-p7 { background: linear-gradient(120deg, #052e16 0%, #166534 55%, #4ade80 100%); }
  .sv-hero.tone-p8 { background: linear-gradient(120deg, #0c0a2b 0%, #312e81 55%, #6366f1 100%); }
  .sv-hero-deco { position: absolute; border-radius: 50%; background: rgba(255,255,255,0.08); }
  .sv-hero-deco.a { width: 420px; height: 420px; right: -120px; top: -160px; }
  .sv-hero-deco.b { width: 260px; height: 260px; left: -80px; bottom: -140px; background: rgba(255,255,255,0.06); }

  .sv-back {
    position: absolute; top: 22px; left: max(30px, calc((100vw - 1200px) / 2));
    display: inline-flex; align-items: center; gap: 6px;
    color: rgba(255,255,255,0.85); font-size: 13px; font-weight: 700; text-decoration: none; z-index: 2;
  }
  .sv-back svg { width: 18px; height: 18px; }
  .sv-back:hover { color: #fff; }
  .sv-loading { max-width: 1200px; margin: 0 auto; padding: 120px 34px; text-align: center; font-size: 15px; font-weight: 700; color: rgba(255,255,255,0.8); }

  .sv-hero-main {
    position: relative; z-index: 1;
    max-width: 1200px; margin: 0 auto;
    padding: 64px 34px 30px;
    display: flex; gap: 28px; align-items: center;
  }
  .sv-avatar {
    flex: none; width: 132px; height: 132px; border-radius: 50%;
    background: rgba(255,255,255,0.18);
    border: 4px solid rgba(255,255,255,0.85);
    box-shadow: 0 12px 30px rgba(0,0,0,0.35);
    display: grid; place-items: center;
    font-size: 56px; font-weight: 800;
    text-shadow: 0 2px 6px rgba(0,0,0,0.25);
  }
  .sv-hero-info { flex: 1; min-width: 0; }
  .sv-name-row { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .sv-name-row h1 { font-size: 30px; font-weight: 800; letter-spacing: 1px; }
  .sv-region {
    font-size: 11px; font-weight: 900; letter-spacing: 1px;
    color: #fff; background: rgba(255,255,255,0.2);
    border: 1px solid rgba(255,255,255,0.4);
    border-radius: 999px; padding: 4px 12px;
  }
  .sv-sub { margin-top: 6px; font-size: 13px; color: rgba(255,255,255,0.72); }
  .sv-stats { display: flex; gap: 36px; margin-top: 18px; }
  .sv-stats div { text-align: center; }
  .sv-stats b {
    display: block; font-size: 20px; font-weight: 800;
    font-variant-numeric: tabular-nums; line-height: 1.2;
  }
  .sv-stats span { font-size: 12px; color: rgba(255,255,255,0.7); }

  .sv-body { max-width: 1200px; margin: 0 auto; padding: 24px 34px; }
  .sv-block { background: #fff; border: 1px solid #e6eefb; border-radius: 16px; padding: 20px; }
  .sv-block-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 14px; }
  .sv-block-title { font-size: 16px; font-weight: 800; color: #2f3238; display: flex; align-items: center; gap: 8px; }
  .sv-block-title em { font-style: normal; font-size: 12px; font-weight: 700; color: #8a94a6; }
  .sv-play-all {
    font-family: var(--font, inherit); font-size: 12px; font-weight: 800;
    color: #fff; background: linear-gradient(140deg, #0b7efc, #0a6ce0);
    border: 0; border-radius: 999px; padding: 7px 16px; cursor: pointer;
    box-shadow: 0 4px 10px rgba(11,126,252,.3);
  }
  .sv-play-all:hover { filter: brightness(1.06); }

  .sv-song {
    display: flex; align-items: center; gap: 14px;
    padding: 12px 8px; border-bottom: 1px solid #f0f4fa;
    cursor: pointer; border-radius: 8px;
    transition: background .15s ease;
  }
  .sv-song:last-child { border-bottom: 0; }
  .sv-song:hover { background: #f7faff; }
  .sv-idx { flex: none; width: 24px; text-align: center; font-size: 14px; font-weight: 800; color: #9aa5b5; }
  .sv-song-main { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 3px; }
  .sv-song-title { font-size: 14px; font-weight: 700; color: #2d3748; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .sv-song-sub { font-size: 12px; color: #9aa5b5; }
  .sv-plays { flex: none; font-size: 12px; font-weight: 600; color: #e07b39; }
  .sv-fav {
    flex: none; border: 0; background: none; cursor: pointer;
    font-size: 19px; color: #b8c2d4; line-height: 1;
  }
  .sv-fav.on { color: #ff5d7a; }
  .sv-empty {
    padding: 44px 20px; text-align: center; line-height: 1.8;
    font-size: 14px; font-weight: 700; color: #8a94a6;
    border: 2px dashed #cfddf0; border-radius: 12px; background: #fbfdff;
  }
  .sv-empty small { font-size: 12px; font-weight: 500; color: #a3adc0; }

  .sv-foot { max-width: 1200px; margin: 0 auto; padding: 8px 34px 0; }
  .sv-foot-link { font-size: 13px; font-weight: 700; color: #0b7efc; text-decoration: none; }
  .sv-foot-link:hover { text-decoration: underline; }
  .toast {
    position: fixed; left: 50%; bottom: 34px; transform: translate(-50%, 130%);
    background: #2f3238; color: #fff; font-weight: 700; font-size: 13.5px;
    padding: 13px 22px; border-radius: 999px; z-index: 20;
    transition: transform .35s cubic-bezier(.2,.9,.3,1.4);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,.5);
  }
  .toast.show { transform: translate(-50%, 0); }

  @media (max-width: 940px) {
    .sv-hero { min-height: auto; }
    .sv-hero-main { flex-direction: column; align-items: flex-start; padding: 56px 22px 24px; }
    .sv-avatar { width: 100px; height: 100px; font-size: 44px; }
    .sv-body { padding: 20px; }
    .sv-stats { gap: 24px; }
  }
</style>
