/* ============================================================
 * 全局播放器状态（单例）
 * HomeView / PlayerBar / NowPlaying 共用同一份响应式状态
 * 并集中管理「收藏 / 播放记录」联动（统一走后端 /api/profile/*）
 * ============================================================ */
import { reactive } from 'vue'

export const player = reactive({
  open: false,      /* 正在播放（全屏详情页）是否展开 */
  song: null,       /* 当前歌曲 { id,title,artist,album,duration,... } */
  queue: [],        /* 播放队列 */
  index: -1,        /* 当前歌曲在队列中的下标 */
  playing: false,   /* 是否正在播放 */
  cur: 0,           /* 当前播放进度（秒） */
  duration: 0,      /* 当前歌曲总时长（秒） */
  mode: 'order'      /* 播放模式：list 列表循环 / one 单曲循环 / order 顺序播放（默认顺序，播完即停） */
})

/* ============================================================
 * 收藏 / 播放记录联动（全局单例，供首页、正在播放、个人中心复用）
 * 与后端约定：POST /api/profile/favorite?songId=  收藏
 *             POST /api/profile/unfavorite?songId=  取消收藏
 *             POST /api/profile/play?songId=  记录播放
 * ============================================================ */
export const favoriteIds = reactive(new Set())

/* 取 token（与其它组件一致） */
function token() {
  try { return localStorage.getItem('shark_token') || '' } catch (e) { return '' }
}
function authHeaders() {
  return { Authorization: 'Bearer ' + token() }
}
function hasAuth() {
  return !!token()
}

/* 拉取当前用户收藏的歌曲 id 集合，供页面判断是否已收藏 */
export async function refreshFavorites() {
  if (!hasAuth()) return
  try {
    const res = await fetch('/api/profile/favorites', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    const list = (res.ok && Array.isArray(d.data)) ? d.data : []
    favoriteIds.clear()
    list.forEach(s => s && s.id && favoriteIds.add(s.id))
  } catch (e) { /* 静默 */ }
}

/* 取歌曲统一 id：热歌榜等来源带 songId（关联主曲库 song 表），否则用自身 id 兜底 */
export function songIdOf(song) {
  if (!song) return null
  return song.songId != null ? song.songId : song.id
}

/* 判断某首歌是否已收藏 */
export function isFavorite(song) {
  const sid = songIdOf(song)
  return !!(sid && favoriteIds.has(sid))
}

/* 收藏 / 取消收藏（自动判断当前状态），返回后端 message 供 toast */
export async function toggleFavorite(song) {
  const sid = songIdOf(song)
  if (!sid) return '参数缺失'
  if (!hasAuth()) return '请先登录后再收藏'
  const fav = isFavorite(song)
  const path = fav ? '/api/profile/unfavorite' : '/api/profile/favorite'
  try {
    const res = await fetch(path + '?songId=' + sid, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    // 无论成功与否都刷新收藏集合，保持 UI 一致
    await refreshFavorites()
    return d.message || (fav ? '已取消收藏' : '已收藏 ❤️')
  } catch (e) {
    return '操作失败，请稍后重试'
  }
}

/* 记录一次播放（进入播放即上报，用于听歌排行 / 总榜单） */
export function recordPlay(song) {
  const sid = songIdOf(song)
  if (!sid) return
  if (!hasAuth()) return
  fetch('/api/profile/play?songId=' + sid, { method: 'POST', headers: authHeaders() }).catch(() => {})
}

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
  // 有真实音源直链则直接用
  if (s.url || s.streamUrl) return s.url || s.streamUrl
  // 走合成音源兜底：用统一 id（热歌榜带 songId 关联主曲库，避免 id 冲突播错歌）
  const sid = songIdOf(s)
  let u = '/api/stream?id=' + encodeURIComponent(sid)
  if (s.duration && Number(s.duration) > 0) {
    u += '&duration=' + encodeURIComponent(s.duration)
  }
  return u
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
  // 不强制全屏展开：点歌只弹底部「正在播放」条，用户可点 ⤢ 自行展开全屏详情页
  // （若已处于全屏详情页，则保持打开状态，切歌不跳走）
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
  /* 播放即记录，用于个人听歌排行 + 听歌总榜单联动（首次播放与切歌都会记录） */
  recordPlay(s)
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
  // 单曲循环：直接重播当前
  if (player.mode === 'one') {
    loadAndPlay()
    return
  }
  // 顺序播放：已是最后一首 → 停止（不再从头循环，避免"单曲循环"错觉）
  if (player.mode === 'order' && player.index >= player.queue.length - 1) {
    player.playing = false
    const a = ensureAudio()
    a.pause()
    player.cur = player.duration || 0
    return
  }
  // 列表循环：取模切换到下一首
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

/* 切换播放模式：list(列表循环) -> one(单曲循环) -> order(顺序播放) */
export function cycleMode() {
  const seq = ['list', 'one', 'order']
  const i = seq.indexOf(player.mode)
  player.mode = seq[(i + 1) % seq.length]
  return player.mode
}

/* 时长格式化：222 -> "3:42"（组件内也会用到） */
export function fmtTime(sec) {
  const v = Math.floor(Number(sec) || 0)
  return Math.floor(v / 60) + ':' + String(v % 60).padStart(2, '0')
}
