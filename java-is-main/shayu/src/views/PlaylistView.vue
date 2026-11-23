<script setup>
/* ============================================================
 * 个人歌单详情页（#/playlist/<id>）
 *  - 打开创建好的歌单，展示歌单内歌曲
 *  - 双击歌曲播放（带整个歌单作为播放队列）
 *  - 从曲库添加歌曲 / 从歌单移除歌曲
 * ============================================================ */
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { player, playTrack, togglePlay, songIdOf } from '../player.js'

/* 当前正在播放的歌曲 id（用于列表高亮） */
const playingId = computed(() => player.song ? songIdOf(player.song) : null)

const API = ''

function authHeaders() {
  let token = ''
  try { token = localStorage.getItem('shark_token') || '' } catch (e) {}
  return { Authorization: 'Bearer ' + token }
}
const toastMsg = ref('')
let toastTimer = null
function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}
function fmtTime(sec) {
  const v = Math.floor(Number(sec) || 0)
  return Math.floor(v / 60) + ':' + String(v % 60).padStart(2, '0')
}
function fmtCount(n) {
  const v = Number(n) || 0
  return v >= 10000 ? (v / 10000).toFixed(1) + '万' : String(v)
}

/* 从 #/playlist/<id> 解析歌单 id */
function parsePlaylistId() {
  const raw = location.hash.replace(/^#\/?/, '').split('?')[0]
  const seg = raw.split('/')
  const id = seg.length >= 2 ? Number(seg[1]) : NaN
  return Number.isFinite(id) && id > 0 ? id : null
}
const playlistId = ref(parsePlaylistId())

const playlist = ref(null)
const songs = ref([])
const loading = ref(true)
const notFound = ref(false)

async function loadPlaylist() {
  if (!playlistId.value) { loading.value = false; notFound.value = true; return }
  loading.value = true
  notFound.value = false
  try {
    // 歌单基本信息：从我的歌单列表里找到对应项
    const pres = await fetch(API + '/api/profile/playlists', { headers: authHeaders() })
    const pd = await pres.json().catch(() => ({}))
    const list = (pres.ok && Array.isArray(pd.data)) ? pd.data : []
    playlist.value = list.find(p => p.id === playlistId.value) || null
    if (!playlist.value) { notFound.value = true; loading.value = false; return }
    // 歌单内歌曲
    const sres = await fetch(API + '/api/profile/playlist/' + playlistId.value + '/songs', { headers: authHeaders() })
    const sd = await sres.json().catch(() => ({}))
    songs.value = (sres.ok && Array.isArray(sd.data)) ? sd.data : []
  } catch (e) {
    notFound.value = true
  } finally {
    loading.value = false
  }
}

/* 双击播放（整个歌单作为队列） */
function playSong(s) {
  playTrack(s, songs.value)
  recordPlay(s)
}
function playAll() {
  if (!songs.value.length) return toast('歌单里还没有歌曲，先添加几首吧 🎵')
  playSong(songs.value[0])
}
function recordPlay(s) {
  if (!s || !s.id) return
  fetch(API + '/api/profile/play?songId=' + s.id, { method: 'POST', headers: authHeaders() }).catch(() => {})
}

/* ===== 添加歌曲弹窗 ===== */
const showAddModal = ref(false)
const library = ref([])
const libKeyword = ref('')
const addingId = ref(null)
async function openAddModal() {
  showAddModal.value = true
  libKeyword.value = ''
  await loadLibrary()
}
async function loadLibrary() {
  try {
    const q = libKeyword.value.trim() ? '?keyword=' + encodeURIComponent(libKeyword.value.trim()) : ''
    const res = await fetch(API + '/api/profile/library/songs' + q, { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    library.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { library.value = [] }
}
function inPlaylist(sid) {
  return songs.value.some(s => s.id === sid)
}
async function addSong(s) {
  if (inPlaylist(s.id)) return toast('这首歌已在歌单里啦 🎵')
  addingId.value = s.id
  try {
    const res = await fetch(API + '/api/profile/playlist/' + playlistId.value + '/song?songId=' + s.id,
      { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok) {
      toast('已添加到歌单 🎵')
      await loadPlaylist()
    } else {
      toast(d.message || '添加失败')
    }
  } catch (e) { toast('网络错误，请稍后重试 🔌') } finally { addingId.value = null }
}

/* ===== 从歌单移除歌曲 ===== */
async function removeSong(s) {
  if (!confirm('从歌单移除「' + s.title + '」？')) return
  try {
    const res = await fetch(API + '/api/profile/playlist/' + playlistId.value + '/song/' + s.id,
      { method: 'DELETE', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast('已从歌单移除'); await loadPlaylist() }
    else toast(d.message || '移除失败')
  } catch (e) { toast('网络错误，请稍后重试 🔌') }
}

function goProfile() { location.hash = '#/profile' }
function goHome() { location.hash = '#/home' }

function onKey(e) { if (e.key === 'Escape' && showAddModal.value) showAddModal.value = false }
onMounted(() => { loadPlaylist(); window.addEventListener('keydown', onKey) })
onUnmounted(() => window.removeEventListener('keydown', onKey))
</script>

<template>
  <main class="pl-shell">
    <header class="pl-hero">
      <div class="pl-hero-deco a"></div>
      <div class="pl-hero-deco b"></div>
      <a class="pl-back" href="#" @click.prevent="goProfile">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回个人主页
      </a>

      <div v-if="loading" class="pl-loading">加载中…</div>
      <div v-else-if="notFound || !playlist" class="pl-empty">没有找到该歌单 🐟</div>

      <div v-else class="pl-hero-main">
        <div class="pl-cover" :class="playlist.coverTone || 'p1'"><span>🎵</span></div>
        <div class="pl-hero-info">
          <span class="pl-tag">🦈 我的歌单</span>
          <h1>{{ playlist.name }}</h1>
          <p class="pl-sub">{{ songs.length }} 首歌曲 · 创建于 {{ (playlist.createTime || '').slice(0, 10) || '—' }}</p>
          <div class="pl-actions">
            <button class="pl-play-all" type="button" @click="playAll">▶ 播放全部</button>
            <button class="pl-add" type="button" @click="openAddModal">＋ 添加歌曲</button>
          </div>
        </div>
      </div>
    </header>

    <section v-if="playlist" class="pl-body">
      <div class="pl-block">
        <h3 class="pl-block-title">歌曲列表 <em>{{ songs.length }}</em></h3>
        <div v-if="songs.length" class="pl-songlist">
          <div class="pl-song-head">
            <span>#</span><span>歌曲</span><span>歌手</span><span>时长</span><span></span>
          </div>
          <div
            v-for="(s, i) in songs" :key="s.id" class="pl-song"
            :class="{ playing: playingId === s.id }"
            title="双击播放"
            @dblclick="playSong(s)"
          >
            <button
              class="pl-song-play" type="button"
              :title="playingId === s.id && player.playing ? '暂停' : '播放'"
              @click.stop="playingId === s.id && player.playing ? togglePlay() : playSong(s)"
            >
              <span v-if="playingId === s.id && player.playing" class="pl-playing-bars"><i></i><i></i><i></i></span>
              <span v-else-if="playingId === s.id">♪</span>
              <span v-else>{{ i + 1 }}</span>
            </button>
            <div class="pl-song-meta">
              <b>{{ s.title }}</b>
              <span class="pl-song-dbl">{{ playingId === s.id && player.playing ? '正在播放' : '单击 ▶ 或双击播放' }}</span>
            </div>
            <span class="pl-song-artist">{{ s.artist }}</span>
            <span class="pl-song-dur">{{ s.duration ? fmtTime(s.duration) : '--:--' }}</span>
            <button class="pl-remove" type="button" title="从歌单移除" @click.stop="removeSong(s)">✕</button>
          </div>
        </div>
        <div v-else class="pl-empty slim">歌单还是空的，点「＋ 添加歌曲」从曲库挑几首吧 🎵</div>
      </div>
    </section>

    <div class="pl-foot">
      <a href="#" class="pl-foot-link" @click.prevent="goProfile">👤 我的主页</a>
      <a href="#" class="pl-foot-link" @click.prevent="goHome">🏠 回到首页</a>
    </div>

    <!-- 添加歌曲弹窗 -->
    <div v-if="showAddModal" class="pl-modal-mask" @click.self="showAddModal = false">
      <div class="pl-modal">
        <div class="pl-modal-head">
          <h3>添加歌曲到「{{ playlist && playlist.name }}」</h3>
          <button class="pl-modal-close" type="button" @click="showAddModal = false">✕</button>
        </div>
        <div class="pl-modal-search">
          <input v-model="libKeyword" type="text" placeholder="搜索歌曲名 / 歌手" @keyup.enter="loadLibrary" />
          <button type="button" @click="loadLibrary">搜索</button>
        </div>
        <div class="pl-modal-list">
          <div v-if="!library.length" class="pl-empty slim">没有匹配的歌曲</div>
          <div v-for="s in library" :key="s.id" class="pl-lib-item">
            <div class="pl-lib-meta">
              <b>{{ s.title }}</b><span>{{ s.artist }} · {{ s.duration ? fmtTime(s.duration) : '--:--' }}</span>
            </div>
            <button
              class="pl-lib-add" type="button"
              :class="{ added: inPlaylist(s.id) }"
              :disabled="inPlaylist(s.id) || addingId === s.id"
              @click="addSong(s)"
            >{{ inPlaylist(s.id) ? '✓ 已加入' : (addingId === s.id ? '…' : '＋ 添加') }}</button>
          </div>
        </div>
        <div class="pl-modal-foot">
          <button type="button" @click="showAddModal = false">完成</button>
        </div>
      </div>
    </div>

    <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
  </main>
</template>

<style>
  body:has(.pl-shell) { padding: 0; display: block; background: #f4f8ff; }
  .pl-shell { position: relative; min-height: 100vh; background: #f4f8ff; padding-bottom: 60px; color: #2f3238; }

  .pl-hero {
    position: relative; min-height: 340px; overflow: hidden;
    background: linear-gradient(120deg, #0a1b33 0%, #0b4a9c 55%, #1287ff 100%); color: #fff;
  }
  .pl-hero-deco { position: absolute; border-radius: 50%; background: rgba(255,255,255,.08); }
  .pl-hero-deco.a { width: 440px; height: 440px; right: -130px; top: -180px; }
  .pl-hero-deco.b { width: 260px; height: 260px; left: -90px; bottom: -150px; background: rgba(255,255,255,.06); }
  .pl-back {
    position: absolute; top: 22px; left: max(30px, calc((100vw - 1200px) / 2));
    display: inline-flex; align-items: center; gap: 6px;
    color: rgba(255,255,255,.85); font-size: 13px; font-weight: 700; text-decoration: none; z-index: 2;
  }
  .pl-back svg { width: 18px; height: 18px; }
  .pl-back:hover { color: #fff; }
  .pl-loading, .pl-empty { position: relative; z-index: 1; padding: 90px max(30px, calc((100vw - 1200px) / 2)); color: rgba(255,255,255,.9); font-size: 15px; }
  .pl-empty.slim { color: #8a9099; padding: 30px; text-align: center; background: #fff; border-radius: 16px; }

  .pl-hero-main {
    position: relative; z-index: 1; max-width: 1200px; margin: 0 auto;
    padding: 76px 30px 40px; display: flex; align-items: center; gap: 30px;
  }
  .pl-cover {
    flex: none; width: 176px; height: 176px; border-radius: 20px;
    display: grid; place-items: center; font-size: 74px;
    box-shadow: 0 16px 40px rgba(0,0,0,.35);
    background: linear-gradient(145deg, #a9c8f0, #7fa9e2);
  }
  .pl-cover.p2 { background: linear-gradient(145deg, #ffb3a7, #ff7e6b); }
  .pl-cover.p3 { background: linear-gradient(145deg, #a7e8d4, #4fc3a1); }
  .pl-cover.p4 { background: linear-gradient(145deg, #ffd59e, #f5a623); }
  .pl-cover.p5 { background: linear-gradient(145deg, #c7b3f0, #8e6be2); }
  .pl-cover.p6 { background: linear-gradient(145deg, #ff9eb0, #f06292); }
  .pl-cover.p7 { background: linear-gradient(145deg, #9fd8f5, #4fa8e0); }
  .pl-cover.p8 { background: linear-gradient(145deg, #b8e0a0, #79bf5a); }
  .pl-hero-info { min-width: 0; }
  .pl-tag { display: inline-block; font-size: 12px; font-weight: 800; letter-spacing: 1px; color: #dbe8fb; }
  .pl-hero-info h1 { margin: 8px 0 10px; font-size: 38px; font-weight: 900; letter-spacing: .5px; }
  .pl-sub { margin: 0 0 20px; font-size: 14px; color: rgba(255,255,255,.78); }
  .pl-actions { display: flex; gap: 12px; flex-wrap: wrap; }
  .pl-play-all, .pl-add {
    border: 0; border-radius: 999px; padding: 11px 24px; font-size: 14px; font-weight: 800; cursor: pointer;
  }
  .pl-play-all { background: #fff; color: #0b4a9c; box-shadow: 0 6px 18px rgba(0,0,0,.2); }
  .pl-play-all:hover { background: #eef4ff; }
  .pl-add { background: rgba(255,255,255,.16); color: #fff; border: 1px solid rgba(255,255,255,.55); }
  .pl-add:hover { background: rgba(255,255,255,.26); }

  .pl-body { max-width: 1200px; margin: 26px auto 0; padding: 0 30px; }
  .pl-block { background: #fff; border-radius: 20px; padding: 24px 26px; box-shadow: 0 8px 30px rgba(20,60,120,.06); }
  .pl-block-title { margin: 0 0 16px; font-size: 18px; font-weight: 900; }
  .pl-block-title em { font-style: normal; font-size: 13px; color: #8a9099; font-weight: 600; margin-left: 6px; }

  .pl-song-head, .pl-song { display: grid; grid-template-columns: 44px 1fr 130px 70px 34px; align-items: center; gap: 8px; }
  .pl-song-head { padding: 0 12px 10px; font-size: 12px; color: #9aa1ac; border-bottom: 1px solid #eef1f6; }
  .pl-song {
    padding: 11px 12px; border-radius: 12px; cursor: default; user-select: none;
    transition: background .15s;
  }
  .pl-song:hover { background: #f4f8ff; }
  .pl-song.playing { background: #e8f1ff; }
  .pl-song.playing .pl-song-meta b, .pl-song.playing .pl-song-dbl { color: #0b7efc; }
  .pl-song-play {
    width: 34px; height: 34px; border: 0; border-radius: 50%; cursor: pointer;
    background: transparent; color: #9aa1ac; font-size: 14px; font-weight: 700;
    display: grid; place-items: center; transition: background .15s, color .15s;
  }
  .pl-song:hover .pl-song-play { background: #dbe8fb; color: #0b7efc; }
  .pl-song.playing .pl-song-play { color: #0b7efc; }
  .pl-playing-bars { display: flex; align-items: flex-end; gap: 2px; height: 14px; }
  .pl-playing-bars i { width: 3px; background: #0b7efc; border-radius: 2px; animation: pl-bar .9s ease-in-out infinite alternate; }
  .pl-playing-bars i:nth-child(1) { height: 60%; animation-delay: -.2s; }
  .pl-playing-bars i:nth-child(2) { height: 100%; animation-delay: -.5s; }
  .pl-playing-bars i:nth-child(3) { height: 45%; animation-delay: -.35s; }
  @keyframes pl-bar { from { transform: scaleY(.4); } to { transform: scaleY(1); } }
  .pl-song-meta { min-width: 0; display: flex; flex-direction: column; gap: 2px; }
  .pl-song-meta b { font-size: 14px; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .pl-song-dbl { font-size: 11px; color: #b6bcc6; }
  .pl-song-artist, .pl-song-dur { font-size: 13px; color: #7d848f; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .pl-remove {
    border: 0; background: transparent; color: #c4cad3; font-size: 15px; cursor: pointer; border-radius: 8px;
    width: 30px; height: 30px;
  }
  .pl-remove:hover { background: #ffe9ec; color: #e0506a; }

  .pl-foot { max-width: 1200px; margin: 24px auto 0; padding: 0 30px; display: flex; gap: 20px; }
  .pl-foot-link { color: #6b7078; font-size: 13px; text-decoration: none; }
  .pl-foot-link:hover { color: #0b7efc; }

  /* 添加歌曲弹窗 */
  .pl-modal-mask {
    position: fixed; inset: 0; z-index: 3000; background: rgba(12,25,48,.55);
    display: grid; place-items: center; padding: 20px;
  }
  .pl-modal {
    width: min(620px, 100%); max-height: 82vh; display: flex; flex-direction: column;
    background: #fff; border-radius: 20px; overflow: hidden; box-shadow: 0 24px 70px rgba(0,0,0,.3);
  }
  .pl-modal-head {
    display: flex; align-items: center; justify-content: space-between;
    padding: 18px 22px; border-bottom: 1px solid #eef1f6;
  }
  .pl-modal-head h3 { margin: 0; font-size: 16px; font-weight: 900; }
  .pl-modal-close { border: 0; background: transparent; font-size: 18px; color: #9aa1ac; cursor: pointer; }
  .pl-modal-search { display: flex; gap: 8px; padding: 14px 22px; }
  .pl-modal-search input {
    flex: 1; border: 1px solid #dfe4ec; border-radius: 10px; padding: 9px 12px; font-size: 13px; outline: none;
  }
  .pl-modal-search input:focus { border-color: #7fa9e2; }
  .pl-modal-search button {
    border: 0; border-radius: 10px; padding: 0 18px; font-size: 13px; font-weight: 800;
    color: #fff; background: #0b7efc; cursor: pointer;
  }
  .pl-modal-list { flex: 1; overflow-y: auto; padding: 0 22px; }
  .pl-lib-item {
    display: flex; align-items: center; justify-content: space-between; gap: 12px;
    padding: 10px 0; border-bottom: 1px solid #f2f4f8;
  }
  .pl-lib-meta { min-width: 0; display: flex; flex-direction: column; gap: 2px; }
  .pl-lib-meta b { font-size: 13px; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .pl-lib-meta span { font-size: 12px; color: #9aa1ac; }
  .pl-lib-add {
    flex: none; border: 1px solid #0b7efc; color: #0b7efc; background: #fff;
    border-radius: 999px; padding: 6px 14px; font-size: 12px; font-weight: 800; cursor: pointer;
  }
  .pl-lib-add:hover { background: #eaf3ff; }
  .pl-lib-add.added { border-color: #d7dce4; color: #aeb4bd; background: #f5f6f8; cursor: default; }
  .pl-modal-foot { padding: 14px 22px; border-top: 1px solid #eef1f6; text-align: right; }
  .pl-modal-foot button {
    border: 0; border-radius: 999px; padding: 9px 26px; font-size: 13px; font-weight: 800;
    color: #fff; background: #0b4a9c; cursor: pointer;
  }

  .toast {
    position: fixed; left: 50%; bottom: 40px; transform: translateX(-50%) translateY(20px);
    background: rgba(20,32,54,.92); color: #fff; padding: 11px 22px; border-radius: 999px;
    font-size: 14px; font-weight: 600; opacity: 0; pointer-events: none; transition: all .28s; z-index: 4000;
  }
  .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

  @media (max-width: 720px) {
    .pl-hero-main { flex-direction: column; align-items: flex-start; padding-top: 66px; }
    .pl-cover { width: 130px; height: 130px; font-size: 54px; }
    .pl-hero-info h1 { font-size: 28px; }
    .pl-song-head, .pl-song { grid-template-columns: 30px 1fr 54px 28px; }
    .pl-song-head span:nth-child(3), .pl-song-artist { display: none; }
  }
</style>
