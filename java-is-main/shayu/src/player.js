/* ============================================================
 * 全局播放器状态（单例）
 * HomeView / PlayerBar / NowPlaying 共用同一份响应式状态
 * ============================================================ */
import { reactive } from 'vue'

export const player = reactive({
  open: false,      /* 正在播放（全屏详情页）是否展开 */
  song: null,       /* 当前歌曲 { id,title,artist,album,duration,... } */
  queue: [],        /* 播放队列 */
  index: -1,        /* 当前歌曲在队列中的下标 */
  playing: false,   /* 是否正在播放 */
  cur: 0,           /* 当前播放进度（秒） */
  duration: 0       /* 当前歌曲总时长（秒） */
})

/* 内部音频实例：整个应用只有一个 <audio> */
let audio = null

function ensureAudio() {
  if (audio) return audio
  audio = new Audio()
  audio.preload = 'auto'
  audio.addEventListener('timeupdate', () => {
    player.cur = audio.currentTime || 0
  })
  audio.addEventListener('durationchange', () => {
    if (Number.isFinite(audio.duration)) player.duration = audio.duration
  })
  audio.addEventListener('play', () => { player.playing = true })
  audio.addEventListener('pause', () => { player.playing = false })
  audio.addEventListener('ended', () => { next() })
  audio.addEventListener('error', () => {
    player.playing = false
    toast('该歌曲暂无可用音源 🔇（仅为演示播放）')
  })
  return audio
}

/* 轻提示：派发自定义事件，由 HomeView 统一弹 toast */
function toast(msg) {
  try {
    window.dispatchEvent(new CustomEvent('shark-toast', { detail: msg }))
  } catch (e) { /* ignore */ }
}

/* 歌曲音源地址：优先用后端给的 url / streamUrl，否则按本地曲库约定走 /api/stream */
export function songUrl(s) {
  if (!s) return ''
  return s.url || s.streamUrl || '/api/stream?id=' + encodeURIComponent(s.id)
}

/* 播放某首歌（可带播放队列） */
export function playTrack(song, queue) {
  if (!song) return
  player.queue = Array.isArray(queue) && queue.length ? queue.slice() : [song]
  player.index = player.queue.findIndex((s) => s.id === song.id)
  if (player.index < 0) {
    player.queue.unshift(song)
    player.index = 0
  }
  player.song = song
  player.open = true
  loadAndPlay()
}

function loadAndPlay() {
  const a = ensureAudio()
  const s = player.song
  if (!s) return
  a.src = songUrl(s)
  player.cur = 0
  player.duration = Number(s.duration) || 0
  a.play().catch(() => { /* 自动播放被拦截或无音源时静默 */ })
}

export function togglePlay() {
  const a = ensureAudio()
  if (!player.song) return
  if (a.paused) a.play().catch(() => {})
  else a.pause()
}

export function seek(sec) {
  const a = ensureAudio()
  if (Number.isFinite(sec)) {
    a.currentTime = sec
    player.cur = sec
  }
}

export function next() {
  if (!player.queue.length) return
  player.index = (player.index + 1) % player.queue.length
  player.song = player.queue[player.index]
  loadAndPlay()
}

export function prev() {
  if (!player.queue.length) return
  player.index = (player.index - 1 + player.queue.length) % player.queue.length
  player.song = player.queue[player.index]
  loadAndPlay()
}

/* 时长格式化：222 -> "3:42"（组件内也会用到） */
export function fmtTime(sec) {
  const v = Math.floor(Number(sec) || 0)
  return Math.floor(v / 60) + ':' + String(v % 60).padStart(2, '0')
}
