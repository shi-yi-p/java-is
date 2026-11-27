<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { player, playTrack, songIdOf } from '../player.js'

/* 当前播放歌曲 id（收藏/排行列表高亮用） */
const playingId = computed(() => player.song ? songIdOf(player.song) : null)

/* ============ 已登录用户信息：沿用 GET /api/me ============ */
const API = ''
const account = ref('')
const nickname = ref('')
const userId = ref(null)
/* 头像：URL 显示为图片，emoji/空值显示为文字 */
const avatarLoadFailed = ref(false)
function isImageAvatar(v) {
  const s = (v || '').trim()
  return /^(https?:\/\/|\/uploads\/|data:image\/)/i.test(s)
}
const avatarSrc = computed(() => {
  const av = profile.value && profile.value.avatar
  return av && isImageAvatar(av) && !avatarLoadFailed.value ? av.trim() : ''
})
const avatarLetter = computed(() => {
  const av = profile.value && profile.value.avatar
  if (av && av.trim() && !isImageAvatar(av)) return av.trim()
  return (nickname.value || account.value || '鲨').slice(0, 1)
})
function onAvatarError() {
  avatarLoadFailed.value = true
  toast('头像图片加载失败，已显示首字母')
}
/* UID：后端 ProfileVO 已返回 uid，兜底本地算 */
const uid = computed(() => {
  const p = profile.value
  if (p && p.uid != null) return p.uid
  return p && p.id ? 10000 + Number(p.id) : null
})

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

/* ============ Tab 切换 ============ */
const tabs = ['动态', '我的歌单', '收藏', '听歌排行', '听歌统计', '好友', '关注']
const activeTab = ref('动态')

/* ============ 真实数据 ============ */
const profile = ref(null)          /* 汇总：关注/粉丝/收藏/播放/歌单 */
const playlists = ref([])          /* 我的歌单（精选歌单，暂无个人歌单接口） */
const favoriteSongs = ref([])      /* 收藏的歌曲（真实） */
const rankSongs = ref([])          /* 听歌排行（真实播放历史） */
const listenStats = ref([])        /* 听歌统计（每首歌次数+时长） */
const moments = ref([])            /* 动态（真实） */
const followingUsers = ref([])     /* 关注的人（真实） */
const followerUsers = ref([])      /* 粉丝（真实） */
const friendUsers = ref([])        /* 好友（互相关注） */

async function loadProfile() {
  const h = authHeaders()

  // 1) 用户信息
  try {
    const res = await fetch(API + '/api/me', { headers: h })
    if (res.status === 401) {
      try { localStorage.removeItem('shark_token') } catch (e) {}
      location.hash = '#/login'
      return
    }
    const d = await res.json().catch(() => ({}))
    if (res.ok && d.data) {
      account.value = d.data.account || ''
      nickname.value = d.data.nickname || d.data.account || '鲨鲨乐迷'
    }
  } catch (e) { /* 静默 */ }

  // 2) 个人主页汇总
  try {
    const res = await fetch(API + '/api/profile', { headers: h })
    const d = await res.json().catch(() => ({}))
    if (res.ok && d.data) {
      profile.value = d.data
      avatarLoadFailed.value = false
      userId.value = d.data.id || null
    }
  } catch (e) { /* 静默 */ }

  // 3) 我的歌单（个人自建歌单，按 user_id 隔离，读取个人接口）
  try {
    const res = await fetch(API + '/api/profile/playlists', { headers: h })
    const d = await res.json().catch(() => ({}))
    if (res.ok && Array.isArray(d.data)) playlists.value = d.data
  } catch (e) { /* 静默 */ }

  // 4) 收藏 / 排行 / 动态 / 关注 / 粉丝 / 好友 / 听歌统计（并行）
  await Promise.all([loadFavorites(), loadHistory(), loadMoments(), loadFollowing(), loadFollowers(), loadFriends(), loadListenStats()])
}

async function loadFavorites() {
  try {
    const res = await fetch(API + '/api/profile/favorites', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    favoriteSongs.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { favoriteSongs.value = [] }
}

async function loadHistory() {
  try {
    const res = await fetch(API + '/api/profile/history', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    rankSongs.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { rankSongs.value = [] }
}

async function loadFriends() {
  try {
    const res = await fetch(API + '/api/profile/friends', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    friendUsers.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { friendUsers.value = [] }
}

async function loadListenStats() {
  try {
    const res = await fetch(API + '/api/profile/listen-stats', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    listenStats.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { listenStats.value = [] }
}

async function loadMoments() {
  try {
    const res = await fetch(API + '/api/profile/moments', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    moments.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { moments.value = [] }
}

/* ============ 自主发布动态 ============ */
const momentDraft = ref('')
const publishing = ref(false)
async function publishMoment() {
  const content = momentDraft.value.trim()
  if (!content) return toast('写点什么再发布吧 ✍️')
  if (content.length > 500) return toast('动态最多 500 字')
  publishing.value = true
  try {
    const res = await fetch(API + '/api/profile/moment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', ...authHeaders() },
      body: JSON.stringify({ content })
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) {
      momentDraft.value = ''
      toast('发布成功 🎉')
      await loadMoments()
    } else {
      toast(d.message || '发布失败')
    }
  } catch (e) { toast('网络错误，请稍后重试 🔌') } finally { publishing.value = false }
}

async function deleteMoment(m) {
  if (!confirm('删除这条动态？')) return
  try {
    const res = await fetch(API + '/api/profile/moment/' + m.id, {
      method: 'DELETE', headers: authHeaders()
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast('动态已删除'); await loadMoments() }
    else toast(d.message || '删除失败')
  } catch (e) { toast('网络错误，请稍后重试 🔌') }
}

async function toggleMomentLike(m) {
  try {
    const res = await fetch(API + '/api/profile/moment/' + m.id + '/like', {
      method: 'POST', headers: authHeaders()
    })
    const d = await res.json().catch(() => ({}))
    if (!res.ok) return toast(d.message || '操作失败')
    // 后端返回 latest liked 状态，本地即时更新 UI（不整表重载）
    m.liked = d.data === true
    m.likeCount = Math.max(0, (m.likeCount || 0) + (m.liked ? 1 : -1))
  } catch (e) { toast('网络错误，请稍后重试 🔌') }
}

async function loadFollowing() {
  try {
    const res = await fetch(API + '/api/profile/following', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    followingUsers.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { followingUsers.value = [] }
}

async function loadFollowers() {
  try {
    const res = await fetch(API + '/api/profile/followers', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    followerUsers.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) { followerUsers.value = [] }
}

onMounted(loadProfile)

/* ============ 双击放大查看头像（大图不带 Lv 角标） ============ */
const showAvatarPreview = ref(false)
const previewTarget = computed(() => {
  const av = profile.value && profile.value.avatar
  return avatarSrc.value || (av && av.trim()) || ''
})
function openAvatarPreview() {
  if (!previewTarget.value) return
  showAvatarPreview.value = true
}
function closeAvatarPreview() { showAvatarPreview.value = false }
function onPreviewKey(e) { if (e.key === 'Escape') closeAvatarPreview() }
onMounted(() => document.addEventListener('keydown', onPreviewKey))
onUnmounted(() => document.removeEventListener('keydown', onPreviewKey))

/* ============ 统计（来自真实汇总接口） ============ */
const stats = computed(() => {
  const p = profile.value
  return {
    following: p ? p.following : 0,
    fans: p ? p.followers : 0,
    listens: p ? p.playCount : 0,
    favoriteCount: p ? p.favoriteCount : 0,
    playlistCount: p ? p.playlistCount : 0
  }
})

/* ============ 鲨鱼等级 + 听歌时长（来自真实汇总接口） ============ */
const level = computed(() => profile.value ? profile.value.level : 1)
const levelName = computed(() => profile.value ? profile.value.levelName : '鱼卵')
const listenSeconds = computed(() => profile.value ? profile.value.listenSeconds : 0)
const nextLevelSeconds = computed(() => profile.value ? profile.value.nextLevelSeconds : 0)

/* 听歌时长格式化：秒 -> "X小时Y分" 或 "Y分Z秒" */
function fmtDuration(sec) {
  const v = Math.floor(Number(sec) || 0)
  if (v < 60) return v + ' 秒'
  if (v < 3600) return Math.floor(v / 60) + ' 分 ' + (v % 60) + ' 秒'
  return Math.floor(v / 3600) + ' 小时 ' + Math.floor((v % 3600) / 60) + ' 分'
}

/* 等级进度百分比：优先用后端返回的 progress，兜底本地计算 */
const levelProgress = computed(() => {
  const p = profile.value
  if (p && typeof p.progress === 'number') {
    return Math.min(100, Math.max(0, p.progress))
  }
  // 兜底：后端未返回 progress 时本地估算
  const sec = listenSeconds.value
  const thresholds = [0, 600, 3600, 21600, 86400, 360000, 1800000, 7200000, 36000000, 180000000]
  const lv = Math.max(0, Math.min(9, level.value - 1))
  const base = thresholds[lv]
  const nextTh = thresholds[lv + 1]
  const span = nextTh - base
  if (span <= 0) return 100
  return Math.min(100, Math.max(0, Math.round(((sec - base) / span) * 100)))
})

/* 是否满级 */
const isMaxLevel = computed(() => level.value >= 10)

function fmtPlays(n) {
  const v = Number(n) || 0
  if (v >= 10000) return (v / 10000).toFixed(1).replace(/\.0$/, '') + '万'
  return String(v)
}

/* ============ 动态图标映射 ============ */
function momentIcon(type) {
  return { listen: '🎧', favorite: '❤️', create_playlist: '🦈', follow: '➕', post: '✍️' }[type] || '🎵'
}

/* ============ 播放（记录播放历史） ============ */
function playSong(s, queue) {
  playTrack(s, queue)
  recordPlay(s)
}
function playAll(list) {
  if (!list || !list.length) return toast('暂无歌曲 🎧')
  playTrack(list[0], list)
  recordPlay(list[0])
}
function recordPlay(s) {
  if (!s || !s.id) return
  fetch(API + '/api/profile/play?songId=' + s.id, { method: 'POST', headers: authHeaders() }).catch(() => {})
  // 播放后刷新排行（异步，不阻塞）
  setTimeout(loadHistory, 800)
}

/* 打开歌单详情 */
function openPlaylist(p) {
  location.hash = '#/playlist/' + p.id
}

/* ============ 个人歌单：新建 / 重命名 / 删除 ============ */
const TONES = ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8']
const showPlaylistModal = ref(false)
const playlistName = ref('')
const editingPlaylist = ref(null)   /* null=新建；否则为重命名对象 */

function openCreatePlaylist() {
  editingPlaylist.value = null
  playlistName.value = ''
  showPlaylistModal.value = true
}
function openRenamePlaylist(p, e) {
  if (e) e.stopPropagation()
  editingPlaylist.value = p
  playlistName.value = p.name
  showPlaylistModal.value = true
}
async function confirmPlaylist() {
  const name = (playlistName.value || '').trim()
  if (!name) return toast('请输入歌单名 🦈')
  try {
    let res
    if (editingPlaylist.value) {
      res = await fetch(API + '/api/profile/playlist/' + editingPlaylist.value.id + '/rename', {
        method: 'POST', headers: { 'Content-Type': 'application/json', ...authHeaders() },
        body: JSON.stringify({ name })
      })
    } else {
      const tone = TONES[Math.floor(Math.random() * TONES.length)]
      res = await fetch(API + '/api/profile/playlist', {
        method: 'POST', headers: { 'Content-Type': 'application/json', ...authHeaders() },
        body: JSON.stringify({ name, coverTone: tone })
      })
    }
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast(d.message || '已保存 🦈'); showPlaylistModal.value = false; loadPlaylists() }
    else toast(d.message || '操作失败')
  } catch (e) { toast('网络错误，请稍后重试 🔌') }
}
async function deletePlaylist(p, e) {
  if (e) e.stopPropagation()
  if (!confirm('确定删除歌单「' + p.name + '」？')) return
  try {
    const res = await fetch(API + '/api/profile/playlist/' + p.id, { method: 'DELETE', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast('已删除 🗑️'); loadPlaylists() }
    else toast(d.message || '删除失败')
  } catch (e) { toast('网络错误 🔌') }
}
async function loadPlaylists() {
  try {
    const res = await fetch(API + '/api/profile/playlists', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok && Array.isArray(d.data)) playlists.value = d.data
  } catch (e) { /* 静默 */ }
}

/* ============ 收藏 / 取消收藏 ============ */
async function toggleFavorite(s) {
  if (!s || !s.id) return
  const isFav = favoriteSongs.value.some(x => x.id === s.id)
  const path = isFav ? '/api/profile/unfavorite' : '/api/profile/favorite'
  try {
    const res = await fetch(API + path + '?songId=' + s.id, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    toast(d.message || (isFav ? '已取消收藏' : '已收藏 ❤️'))
    loadFavorites()
    loadMoments()
    loadProfile()
  } catch (e) {
    toast('操作失败，请稍后重试')
  }
}
function isFavorite(s) {
  return favoriteSongs.value.some(x => x.id === s.id)
}

/* ============ 关注 / 取消关注（演示：对歌手不可用，关注列表操作用） ============ */
async function followUser(u) {
  if (!u || !u.id) return
  try {
    const res = await fetch(API + '/api/profile/follow?targetId=' + u.id, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    toast(d.message || '已关注')
    loadFollowing()
    loadProfile()
  } catch (e) { toast('操作失败') }
}

async function unfollow(u) {
  if (!u || !u.id) return
  try {
    const res = await fetch(API + '/api/profile/unfollow?targetId=' + u.id, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    toast(d.message || '已取消关注')
    loadFollowing()
    loadProfile()
  } catch (e) { toast('操作失败') }
}

/* 返回首页 */
function goHome() { location.hash = '#/home' }

/* 跳转听歌总排名榜 */
function goRanking() { location.hash = '#/ranking' }

/* 双击好友头像 → 打开对方主页（#/user/<数据库 id>） */
function openUserPage(u) {
  const id = u && (u.id || (u.uid ? Number(u.uid) - 10000 : null))
  if (!id) return toast('该用户暂无主页')
  location.hash = '#/user/' + id
}

/* 编辑资料（真实：改头像 + 昵称） */
const showEditModal = ref(false)
const editNickname = ref('')
const editAvatar = ref('')
const avatarUrlInput = ref('')
const fileInputRef = ref(null)
const uploading = ref(false)
const AVATAR_PRESETS = ['🦈', '🐬', '🐳', '🐟', '🐙', '🦀', '🎵', '🎧', '🎸', '🎤', '⭐', '🔥']

const editAvatarSrc = computed(() => isImageAvatar(editAvatar.value) ? editAvatar.value.trim() : '')
const editAvatarText = computed(() => {
  const av = editAvatar.value && editAvatar.value.trim()
  return av && !isImageAvatar(av) ? av : (nickname.value || account.value || '鲨').slice(0, 1)
})

function openEditProfile() {
  editNickname.value = nickname.value || ''
  editAvatar.value = profile.value && profile.value.avatar ? profile.value.avatar : ''
  avatarUrlInput.value = isImageAvatar(editAvatar.value) ? editAvatar.value : ''
  showEditModal.value = true
}

function pickAvatar(a) {
  editAvatar.value = a
  avatarUrlInput.value = ''
}

/** 粘贴网络图片地址（http/https 或本站 /uploads/...） */
function applyAvatarUrl() {
  const url = avatarUrlInput.value.trim()
  if (!url) return toast('请先粘贴图片地址')
  if (!isImageAvatar(url)) return toast('请粘贴 http(s) 开头的图片地址')
  editAvatar.value = url
  toast('已选用网络图片，点保存生效 ✅')
}

function resetAvatar() {
  editAvatar.value = ''
  avatarUrlInput.value = ''
  toast('已恢复默认头像，点保存生效')
}

/* ============ 本地头像：框选图片区域裁剪后上传 ============ */
const showCropModal = ref(false)
const cropCanvasRef = ref(null)
let cropSrcImage = null          /* 原始 HTMLImageElement */
let cropScale = 1                /* 画布坐标 → 原图像素 比例 */
const cropSel = ref(null)        /* { x, y, size } 画布坐标内的正方形选区 */
let cropDragging = false
let cropDragStart = null

/** 选图后先打开裁剪弹窗，不再直接上传 */
function onAvatarFileSelected(e) {
  const file = e.target.files && e.target.files[0]
  e.target.value = ''
  if (!file) return
  if (!file.type || !file.type.startsWith('image/')) return toast('请选择图片文件')
  if (file.size > 4 * 1024 * 1024) return toast('原图不能超过 4MB')
  const reader = new FileReader()
  reader.onload = () => {
    const img = new Image()
    img.onload = () => {
      cropSrcImage = img
      showCropModal.value = true
      nextTick(initCropCanvas)
    }
    img.onerror = () => toast('图片加载失败，请换一张试试')
    img.src = reader.result
  }
  reader.readAsDataURL(file)
}

/** 把原图等比画进画布（最长边 ≤ 480），默认选中居中正方形 */
function initCropCanvas() {
  const cv = cropCanvasRef.value
  if (!cv || !cropSrcImage) return
  const maxSide = 480
  const nw = cropSrcImage.naturalWidth
  const nh = cropSrcImage.naturalHeight
  cropScale = Math.max(nw, nh) / maxSide
  const w = Math.round(nw / cropScale)
  const h = Math.round(nh / cropScale)
  cv.width = w
  cv.height = h
  const size = Math.round(Math.min(w, h) * 0.8)
  cropSel.value = { x: Math.round((w - size) / 2), y: Math.round((h - size) / 2), size }
  drawCrop()
}

/** 重绘画布：原图 + 暗化遮罩 + 高亮选区 */
function drawCrop() {
  const cv = cropCanvasRef.value
  if (!cv || !cropSrcImage) return
  const ctx = cv.getContext('2d')
  ctx.clearRect(0, 0, cv.width, cv.height)
  ctx.drawImage(cropSrcImage, 0, 0, cv.width, cv.height)
  const s = cropSel.value
  if (!s) return
  ctx.fillStyle = 'rgba(10,20,40,0.55)'
  ctx.fillRect(0, 0, cv.width, cv.height)
  // 挖空选区并重新绘制该区域（清晰）
  ctx.clearRect(s.x, s.y, s.size, s.size)
  ctx.drawImage(cropSrcImage, s.x * cropScale, s.y * cropScale, s.size * cropScale, s.size * cropScale,
    s.x, s.y, s.size, s.size)
  // 九宫格参考线
  ctx.strokeStyle = 'rgba(255,255,255,0.45)'
  ctx.lineWidth = 1
  for (let i = 1; i < 3; i++) {
    const gx = s.x + (s.size * i) / 3
    const gy = s.y + (s.size * i) / 3
    ctx.beginPath(); ctx.moveTo(gx, s.y); ctx.lineTo(gx, s.y + s.size); ctx.stroke()
    ctx.beginPath(); ctx.moveTo(s.x, gy); ctx.lineTo(s.x + s.size, gy); ctx.stroke()
  }
  // 选区边框
  ctx.strokeStyle = '#fff'
  ctx.lineWidth = 2
  ctx.strokeRect(s.x, s.y, s.size, s.size)
}

/** 指针在画布内的坐标 */
function cropPointerPos(e) {
  const cv = cropCanvasRef.value
  const rect = cv.getBoundingClientRect()
  return {
    x: (e.clientX - rect.left) * (cv.width / rect.width),
    y: (e.clientY - rect.top) * (cv.height / rect.height)
  }
}

function onCropDown(e) {
  const p = cropPointerPos(e)
  cropDragging = true
  cropDragStart = p
  cropSel.value = { x: p.x, y: p.y, size: 1 }
  if (cropCanvasRef.value) cropCanvasRef.value.setPointerCapture(e.pointerId)
  drawCrop()
}
function onCropMove(e) {
  if (!cropDragging || !cropDragStart) return
  const cv = cropCanvasRef.value
  const p = cropPointerPos(e)
  // 取 x/y 位移较小者为边长，保证正方形且不越界
  let dx = p.x - cropDragStart.x
  let dy = p.y - cropDragStart.y
  let size = Math.min(Math.abs(dx), Math.abs(dy))
  size = Math.max(20, size)
  let x = dx >= 0 ? cropDragStart.x : cropDragStart.x - size
  let y = dy >= 0 ? cropDragStart.y : cropDragStart.y - size
  x = Math.max(0, Math.min(x, cv.width - size))
  y = Math.max(0, Math.min(y, cv.height - size))
  cropSel.value = { x: Math.round(x), y: Math.round(y), size: Math.round(size) }
  drawCrop()
}
function onCropUp(e) {
  cropDragging = false
  cropDragStart = null
  if (cropCanvasRef.value && e.pointerId != null) {
    try { cropCanvasRef.value.releasePointerCapture(e.pointerId) } catch (err) { /* ignore */ }
  }
}

/** 把选区裁剪成正方形 PNG 并上传 */
async function confirmCrop() {
  const s = cropSel.value
  if (!cropSrcImage || !s || s.size < 20) return toast('请在图片上框选一块区域')
  const outSize = 400
  const out = document.createElement('canvas')
  out.width = outSize
  out.height = outSize
  const ctx = out.getContext('2d')
  ctx.drawImage(
    cropSrcImage,
    s.x * cropScale, s.y * cropScale, s.size * cropScale, s.size * cropScale,
    0, 0, outSize, outSize
  )
  const blob = await new Promise(resolve => out.toBlob(resolve, 'image/png'))
  if (!blob) return toast('裁剪失败，请重试')
  uploading.value = true
  try {
    const fd = new FormData()
    fd.append('file', blob, 'avatar.png')
    const res = await fetch(API + '/api/profile/avatar/upload', {
      method: 'POST', headers: authHeaders(), body: fd
    })
    const d = await res.json().catch(() => ({}))
    if (!res.ok) return toast(d.message || '上传失败')
    editAvatar.value = (d.data && d.data.avatar) || ''
    avatarUrlInput.value = ''
    showCropModal.value = false
    toast('头像已更新 ✅')
    // 上传接口已直接写库，立即同步主页数据，无需再点保存
    await loadProfile()
  } catch (err) {
    toast('上传失败，请稍后重试')
  } finally {
    uploading.value = false
  }
}

function closeCropModal() {
  showCropModal.value = false
  cropSrcImage = null
  cropSel.value = null
}

async function saveEditProfile() {
  const nn = editNickname.value.trim()
  if (!nn) return toast('昵称不能为空')
  try {
    // 改昵称
    let res = await fetch(API + '/api/profile/nickname', {
      method: 'POST', headers: { 'Content-Type': 'application/json', ...authHeaders() },
      body: JSON.stringify({ nickname: nn })
    })
    let d = await res.json().catch(() => ({}))
    if (!res.ok) { toast(d.message || '昵称更新失败'); return }
    // 改头像（空字符串 = 恢复默认）
    res = await fetch(API + '/api/profile/avatar', {
      method: 'POST', headers: { 'Content-Type': 'application/json', ...authHeaders() },
      body: JSON.stringify({ avatar: editAvatar.value.trim() })
    })
    d = await res.json().catch(() => ({}))
    if (!res.ok) { toast(d.message || '头像更新失败'); return }
    toast('资料已更新 ✅')
    showEditModal.value = false
    avatarLoadFailed.value = false
    loadProfile()
  } catch (e) { toast('网络错误，请稍后重试 🔌') }
}

function coming(t) { toast(t + ' 开发中 🚧') }
</script>

<template>
  <main class="pf-shell">
    <!-- ================= 顶部横幅 ================= -->
    <header class="pf-hero">
      <div class="pf-hero-deco a"></div>
      <div class="pf-hero-deco b"></div>

      <a class="pf-back" href="#" @click.prevent="goHome">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回首页
      </a>

      <div class="pf-hero-main">
        <div
          class="pf-avatar" :class="{ zoomable: !!previewTarget }"
          :title="previewTarget ? '双击查看大图' : ''"
          @dblclick="openAvatarPreview"
        >
          <img v-if="avatarSrc" class="pf-avatar-img" :src="avatarSrc" alt="头像" @error="onAvatarError" />
          <span v-else>{{ avatarLetter }}</span>
        </div>
        <div class="pf-hero-info">
          <div class="pf-name-row">
            <h1>{{ nickname || '鲨鲨乐迷' }}</h1>
            <span class="pf-vip">{{ levelName }}</span>
            <button class="pf-edit" type="button" @click="openEditProfile">✎ 编辑资料</button>
          </div>
          <p class="pf-account">账号：{{ account || '未登录' }} · UID：{{ uid || '—' }}</p>

          <!-- 鲨鱼等级卡片（醒目展示） -->
          <div class="pf-level-card">
            <div class="pf-level-card-top">
              <span class="pf-level-lv">Lv.{{ level }}</span>
              <span class="pf-level-name">{{ levelName }}</span>
              <span v-if="isMaxLevel" class="pf-level-max">👑 已满级</span>
              <span v-else class="pf-level-next">距下一级还需 {{ fmtDuration(nextLevelSeconds) }}</span>
            </div>
            <div class="pf-level-bar">
              <div class="pf-level-fill" :style="{ width: levelProgress + '%' }"></div>
            </div>
            <div class="pf-level-card-bottom">
              <span>累计听歌 {{ fmtDuration(listenSeconds) }}</span>
              <span class="pf-level-pct">{{ levelProgress }}%</span>
            </div>
          </div>

          <div class="pf-stats">
            <div><b>{{ stats.following }}</b><span>关注</span></div>
            <div><b>{{ stats.fans }}</b><span>粉丝</span></div>
            <div><b>{{ fmtPlays(stats.listens) }}</b><span>播放</span></div>
            <div><b>{{ fmtDuration(listenSeconds) }}</b><span>听歌时长</span></div>
          </div>

          <div class="pf-actions">
            <button class="pf-btn primary" type="button" @click="playAll(rankSongs)">▶ 播放我的音乐</button>
            <button class="pf-btn ghost" type="button" @click="goRanking">🏆 听歌总排名</button>
          </div>
        </div>
      </div>
    </header>

    <!-- ================= Tab 栏 ================= -->
    <nav class="pf-tabs">
      <button
        v-for="t in tabs" :key="t" type="button"
        :class="{ on: activeTab === t }"
        @click="activeTab = t"
      >{{ t }}</button>
    </nav>

    <!-- ================= 主体：左内容 + 右侧栏 ================= -->
    <div class="pf-body">
      <!-- 左：主内容 -->
      <section class="pf-main">
        <!-- 动态 -->
        <template v-if="activeTab === '动态'">
          <div class="pf-block">
            <h3 class="pf-block-title">我的动态</h3>
            <!-- 自主发布 -->
            <div class="pf-publish">
              <textarea
                v-model="momentDraft"
                class="pf-publish-input"
                maxlength="500"
                rows="3"
                placeholder="分享此刻的心情、正在听的歌…… ✍️"
                @keyup.ctrl.enter="publishMoment"
              ></textarea>
              <div class="pf-publish-bar">
                <span class="pf-publish-count">{{ momentDraft.length }}/500 · Ctrl+Enter 发布</span>
                <button class="pf-publish-btn" type="button" :disabled="publishing" @click="publishMoment">
                  {{ publishing ? '发布中…' : '发布动态' }}
                </button>
              </div>
            </div>
            <div v-if="moments.length" class="pf-moment-list">
              <div v-for="m in moments" :key="m.id" class="pf-moment">
                <span class="pf-moment-ico">{{ momentIcon(m.type) }}</span>
                <div class="pf-moment-body">
                  <p>{{ m.content }}</p>
                  <span class="pf-moment-time">{{ m.createTime }}</span>
                </div>
                <div class="pf-moment-ops">
                  <button
                    class="pf-moment-like" :class="{ on: m.liked }" type="button"
                    :title="m.liked ? '取消点赞' : '点赞'"
                    @click="toggleMomentLike(m)"
                  >{{ m.liked ? '❤️' : '🤍' }} <span>{{ m.likeCount || 0 }}</span></button>
                  <button
                    v-if="m.type === 'post'" class="pf-moment-del" type="button"
                    title="删除动态" @click="deleteMoment(m)"
                  >🗑</button>
                </div>
              </div>
            </div>
            <div v-else class="pf-empty">还没有动态，在上面写下第一条吧 ✍️</div>
          </div>
        </template>

        <!-- 我的歌单 -->
        <template v-else-if="activeTab === '我的歌单'">
          <div class="pf-block">
            <div class="pf-block-head">
              <h3 class="pf-block-title">创建的歌单 <em>{{ playlists.length }}</em></h3>
              <button class="pf-create-btn" type="button" @click="openCreatePlaylist">＋ 新建歌单</button>
            </div>
            <div v-if="playlists.length" class="pf-cards">
              <div v-for="p in playlists" :key="p.id" class="pf-card" title="点击进入歌单" @click="openPlaylist(p)">
                <div class="pf-card-cover" :class="p.coverTone || 'p1'">
                  <span class="pf-card-icon">🎵</span>
                  <span class="pf-card-plays">🦈 {{ p.songCount || 0 }} 首</span>
                </div>
                <div class="pf-card-info">
                  <b>{{ p.name }}</b>
                  <span class="pf-card-ops">
                    <button type="button" @click.stop="openRenamePlaylist(p, $event)">重命名</button>
                    <button type="button" class="del" @click.stop="deletePlaylist(p, $event)">删除</button>
                  </span>
                </div>
              </div>
            </div>
            <div v-else class="pf-empty">还没有创建歌单，点右上角「＋ 新建歌单」创建你的第一份歌单吧 🦈</div>
          </div>
        </template>

        <!-- 收藏 -->
        <template v-else-if="activeTab === '收藏'">
          <div class="pf-block">
            <h3 class="pf-block-title">收藏的歌曲 <em>{{ favoriteSongs.length }}</em></h3>
            <div v-if="favoriteSongs.length" class="pf-songlist">
              <div v-for="(s, i) in favoriteSongs" :key="s.id" class="pf-song" :class="{ playing: playingId === s.id }" title="双击播放" @dblclick="playSong(s, favoriteSongs)">
                <span class="pf-song-idx" :class="{ top: i < 3, on: playingId === s.id }">{{ playingId === s.id ? '♪' : (i + 1) }}</span>
                <div class="pf-song-meta">
                  <b>{{ s.title }}</b>
                  <span>{{ s.artist }} · {{ playingId === s.id && player.playing ? '正在播放' : '双击播放' }}</span>
                </div>
                <span class="pf-song-dur">{{ s.duration ? Math.floor(s.duration / 60) + ':' + String(s.duration % 60).padStart(2, '0') : '--:--' }}</span>
                <button class="pf-fav-btn on" type="button" @click.stop="toggleFavorite(s)" title="取消收藏">❤</button>
              </div>
            </div>
            <div v-else class="pf-empty">还没有收藏歌曲 ❤️ 去歌单/榜单里点 ❤ 收藏吧</div>
          </div>
        </template>

        <!-- 听歌排行 -->
        <template v-else-if="activeTab === '听歌排行'">
          <div class="pf-block">
            <h3 class="pf-block-title">我的听歌排行 <em>TOP {{ rankSongs.length }}</em></h3>
            <div v-if="rankSongs.length" class="pf-songlist">
              <div v-for="(s, i) in rankSongs" :key="s.id" class="pf-song" :class="{ playing: playingId === s.id }">
                <span class="pf-song-idx" :class="{ top: i < 3, on: playingId === s.id }" @click="playSong(s, rankSongs)">{{ playingId === s.id ? '♪' : (i + 1) }}</span>
                <div class="pf-song-meta" @click="playSong(s, rankSongs)">
                  <b>{{ s.title }}</b>
                  <span>{{ s.artist }} · {{ s.album }}</span>
                </div>
                <span class="pf-song-plays">{{ fmtPlays(s.plays) }} 次</span>
                <button class="pf-fav-btn" :class="{ on: isFavorite(s) }" type="button" @click.stop="toggleFavorite(s)" :title="isFavorite(s) ? '取消收藏' : '收藏'">❤</button>
              </div>
            </div>
            <div v-else class="pf-empty">暂无听歌记录，去听几首歌吧 🎵</div>
          </div>
        </template>

        <!-- 听歌统计 -->
        <template v-else-if="activeTab === '听歌统计'">
          <div class="pf-block">
            <h3 class="pf-block-title">听歌统计 <em>共 {{ listenStats.length }} 首</em></h3>
            <div v-if="listenStats.length" class="pf-songlist">
              <div v-for="(s, i) in listenStats" :key="s.songId" class="pf-song">
                <span class="pf-song-idx" :class="{ top: i < 3 }">{{ i + 1 }}</span>
                <div class="pf-song-meta">
                  <b>{{ s.title }}</b>
                  <span>{{ s.artist }}</span>
                </div>
                <span class="pf-stat-cell">{{ s.playCount }} 次</span>
                <span class="pf-stat-cell strong">{{ fmtDuration(s.totalSeconds) }}</span>
              </div>
            </div>
            <div v-else class="pf-empty">还没有听歌记录，去听几首歌吧 🎧</div>
          </div>
        </template>

        <!-- 好友 -->
        <template v-else-if="activeTab === '好友'">
          <div class="pf-block">
            <h3 class="pf-block-title">好友 <em>{{ friendUsers.length }}</em></h3>
            <p class="pf-block-hint">互相关注即成为好友 🐟</p>
            <div v-if="friendUsers.length" class="pf-userlist">
              <div v-for="u in friendUsers" :key="u.id" class="pf-user">
                <span
                  class="pf-user-ava zoomable" title="双击查看主页"
                  @dblclick="openUserPage(u)"
                >
                  <img
                    v-if="isImageAvatar(u.avatar)" :src="u.avatar"
                    :alt="u.nickname || u.account"
                  />
                  <span v-else>{{ u.avatar || (u.nickname || u.account).slice(0, 1) }}</span>
                </span>
                <div class="pf-user-mid">
                  <span class="pf-user-name">{{ u.nickname || u.account }}</span>
                  <span class="pf-user-uid">UID：{{ u.uid }}</span>
                </div>
                <button class="pf-user-btn" type="button" @click="unfollow(u)">解除好友</button>
              </div>
            </div>
            <div v-else class="pf-empty">还没有好友，去关注别人并让对方回关吧 🤝</div>
          </div>
        </template>

        <!-- 关注 -->
        <template v-else>
          <div class="pf-block">
            <h3 class="pf-block-title">关注 <em>{{ followingUsers.length }}</em></h3>
            <div v-if="followingUsers.length" class="pf-userlist">
              <div v-for="u in followingUsers" :key="u.id" class="pf-user">
                <span
                  class="pf-user-ava zoomable" title="双击查看主页"
                  @dblclick="openUserPage(u)"
                >
                  <img
                    v-if="isImageAvatar(u.avatar)" :src="u.avatar"
                    :alt="u.nickname || u.account"
                  />
                  <span v-else>{{ u.avatar || (u.nickname || u.account).slice(0, 1) }}</span>
                </span>
                <div class="pf-user-mid">
                  <span class="pf-user-name">{{ u.nickname || u.account }}</span>
                  <span class="pf-user-uid">UID：{{ u.uid }}</span>
                </div>
                <button class="pf-user-btn" type="button" @click="followingUsers = followingUsers.filter(x => x.id !== u.id); unfollow(u)">已关注</button>
              </div>
            </div>
            <div v-else class="pf-empty">还没有关注任何人 👀</div>
          </div>

          <div class="pf-block">
            <h3 class="pf-block-title">粉丝 <em>{{ followerUsers.length }}</em></h3>
            <div v-if="followerUsers.length" class="pf-userlist">
              <div v-for="u in followerUsers" :key="u.id" class="pf-user">
                <span
                  class="pf-user-ava zoomable" title="双击查看主页"
                  @dblclick="openUserPage(u)"
                >
                  <img
                    v-if="isImageAvatar(u.avatar)" :src="u.avatar"
                    :alt="u.nickname || u.account"
                  />
                  <span v-else>{{ u.avatar || (u.nickname || u.account).slice(0, 1) }}</span>
                </span>
                <div class="pf-user-mid">
                  <span class="pf-user-name">{{ u.nickname || u.account }}</span>
                  <span class="pf-user-uid">UID：{{ u.uid }}</span>
                </div>
              </div>
            </div>
            <div v-else class="pf-empty">还没有粉丝 🐟</div>
          </div>
        </template>
      </section>

      <!-- 右：侧边栏 -->
      <aside class="pf-side">
        <div class="pf-block side">
          <h3 class="pf-block-title">创建的歌单</h3>
          <a v-for="p in playlists.slice(0, 5)" :key="p.id" href="#" class="pf-side-item" @click.prevent="openPlaylist(p)">
            <span class="pf-side-cover" :class="p.coverTone || 'p1'">🎵</span>
            <span class="pf-side-name">{{ p.name }}</span>
            <span class="pf-side-count">{{ p.songCount || 0 }} 首</span>
          </a>
          <div v-if="!playlists.length" class="pf-empty slim">暂无歌单</div>
        </div>

        <div class="pf-block side">
          <h3 class="pf-block-title">听歌排行</h3>
          <a v-for="(s, i) in rankSongs.slice(0, 5)" :key="s.id" href="#" class="pf-side-item" @click.prevent="playSong(s, rankSongs)">
            <span class="pf-side-rank" :class="{ top: i < 3 }">{{ i + 1 }}</span>
            <span class="pf-side-name">{{ s.title }}</span>
            <span class="pf-side-count">{{ fmtPlays(s.plays) }}</span>
          </a>
          <div v-if="!rankSongs.length" class="pf-empty slim">暂无排行</div>
        </div>
      </aside>
    </div>

    <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>

    <!-- 新建 / 重命名 歌单 弹窗 -->
    <div v-if="showPlaylistModal" class="pf-mask" @click.self="showPlaylistModal = false">
      <div class="pf-modal">
        <h3>{{ editingPlaylist ? '重命名歌单' : '新建歌单' }}</h3>
        <input
          class="pf-modal-input"
          v-model="playlistName"
          type="text"
          maxlength="30"
          :placeholder="editingPlaylist ? '输入新歌单名' : '给歌单起个名字吧'"
          @keyup.enter="confirmPlaylist"
        />
        <div class="pf-modal-foot">
          <button class="pf-modal-cancel" type="button" @click="showPlaylistModal = false">取消</button>
          <button class="pf-modal-ok" type="button" @click="confirmPlaylist">{{ editingPlaylist ? '保存' : '创建' }}</button>
        </div>
      </div>
    </div>

    <!-- 编辑资料（头像 + 昵称）弹窗 -->
    <div v-if="showEditModal" class="pf-mask" @click.self="showEditModal = false">
      <div class="pf-modal pf-edit-modal">
        <h3>编辑资料</h3>

        <label class="pf-edit-label">头像</label>
        <div class="pf-avatar-editor">
          <div class="pf-avatar-preview" :class="{ image: !!editAvatarSrc }">
            <img v-if="editAvatarSrc" :src="editAvatarSrc" alt="头像预览" />
            <span v-else>{{ editAvatarText }}</span>
          </div>
          <div class="pf-avatar-editor-side">
            <div class="pf-avatar-picker">
              <button
                v-for="a in AVATAR_PRESETS" :key="a" type="button"
                class="pf-avatar-opt" :class="{ on: editAvatar === a }"
                @click="pickAvatar(a)"
              >{{ a }}</button>
            </div>
            <div class="pf-avatar-actions">
              <button class="pf-avatar-action" type="button" @click="resetAvatar">恢复默认</button>
              <button class="pf-avatar-action" type="button" @click="fileInputRef && fileInputRef.click()">
                {{ uploading ? '上传中…' : '上传本地图片' }}
              </button>
              <input
                ref="fileInputRef" class="pf-hidden-file" type="file"
                accept="image/png,image/jpeg,image/gif,image/webp,image/bmp"
                @change="onAvatarFileSelected"
              />
            </div>
          </div>
        </div>

        <label class="pf-edit-label">网络图片地址</label>
        <div class="pf-url-row">
          <input
            class="pf-modal-input" v-model="avatarUrlInput" type="url"
            placeholder="粘贴图片地址，如 https://.../avatar.png"
          />
          <button class="pf-avatar-action" type="button" @click="applyAvatarUrl">使用</button>
        </div>
        <p class="pf-avatar-tip">支持网络图片 URL 或本地上传（原图≤4MB，上传后可框选区域裁剪），点“保存”后生效。</p>

        <label class="pf-edit-label">昵称</label>
        <input
          class="pf-modal-input"
          v-model="editNickname"
          type="text"
          maxlength="20"
          placeholder="输入新昵称"
        />

        <div class="pf-modal-foot">
          <button class="pf-modal-cancel" type="button" @click="showEditModal = false">取消</button>
          <button class="pf-modal-ok" type="button" @click="saveEditProfile">保存</button>
        </div>
      </div>
    </div>

    <!-- 头像大图预览：只渲染头像本身，不渲染 Lv 角标 -->
    <div v-if="showAvatarPreview && previewTarget" class="pf-lightbox" @click="closeAvatarPreview">
      <img v-if="avatarSrc" class="pf-lightbox-img" :src="avatarSrc" alt="头像大图" />
      <span v-else class="pf-lightbox-emoji">{{ avatarLetter }}</span>
      <p>点击任意位置或按 Esc 关闭</p>
    </div>

    <!-- 头像框选裁剪弹窗 -->
    <div v-if="showCropModal" class="pf-mask crop-mask" @click.self="closeCropModal">
      <div class="pf-modal pf-crop-modal">
        <h3>框选头像区域</h3>
        <p class="pf-crop-tip">在图片上按住鼠标拖动画框，选取想作为头像的区域（自动取正方形）。</p>
        <div class="pf-crop-stage">
          <canvas
            ref="cropCanvasRef"
            class="pf-crop-canvas"
            @pointerdown.prevent="onCropDown"
            @pointermove.prevent="onCropMove"
            @pointerup="onCropUp"
            @pointercancel="onCropUp"
          ></canvas>
        </div>
        <div class="pf-modal-foot">
          <button class="pf-modal-cancel" type="button" @click="closeCropModal">取消</button>
          <button class="pf-modal-ok" type="button" :disabled="uploading" @click="confirmCrop">
            {{ uploading ? '上传中…' : '使用选区作头像' }}
          </button>
        </div>
      </div>
    </div>
  </main>
</template>

<style>
  body:has(.pf-shell) {
    padding: 0;
    display: block;
    background: #f4f8ff;
  }
  .pf-shell {
    position: relative;
    min-height: 100vh;
    background: #f4f8ff;
    padding-bottom: 60px;
  }

  /* ================= 顶部横幅 ================= */
  .pf-hero {
    position: relative;
    height: 300px;
    background: linear-gradient(120deg, #0a1b33 0%, #0b4a9c 55%, #1287ff 100%);
    color: #fff;
    overflow: hidden;
  }
  .pf-hero-deco {
    position: absolute;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.08);
  }
  .pf-hero-deco.a { width: 420px; height: 420px; right: -120px; top: -160px; }
  .pf-hero-deco.b { width: 260px; height: 260px; left: -80px; bottom: -140px; background: rgba(255, 255, 255, 0.06); }

  .pf-back {
    position: absolute;
    top: 22px; left: max(30px, calc((100vw - 1200px) / 2));
    display: inline-flex; align-items: center; gap: 6px;
    color: rgba(255, 255, 255, 0.85);
    font-size: 13px; font-weight: 700; text-decoration: none;
    z-index: 2;
  }
  .pf-back svg { width: 18px; height: 18px; }
  .pf-back:hover { color: #fff; }

  .pf-hero-main {
    position: relative;
    z-index: 1;
    max-width: 1200px;
    margin: 0 auto;
    padding: 66px 34px 0;
    display: flex;
    gap: 28px;
    align-items: flex-start;
  }
  .pf-avatar {
    position: relative;
    flex: none;
    width: 132px; height: 132px;
    border-radius: 50%;
    background: linear-gradient(150deg, var(--pink-soft), var(--pink));
    border: 4px solid rgba(255, 255, 255, 0.85);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
    display: grid; place-items: center;
    font-size: 56px; font-weight: 800; color: var(--ink);
    overflow: hidden; user-select: none;
  }
  .pf-avatar-img {
    width: 100%; height: 100%;
    border-radius: 50%; object-fit: cover; display: block;
  }
  .pf-avatar.zoomable { cursor: zoom-in; }
  .pf-lightbox {
    position: fixed; inset: 0; z-index: 9999;
    background: rgba(8, 12, 24, .86);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 16px; padding: 32px; backdrop-filter: blur(6px);
  }
  .pf-lightbox-img {
    max-width: min(80vw, 720px); max-height: 78vh;
    border-radius: 18px; object-fit: contain;
    background: #fff; box-shadow: 0 24px 70px rgba(0,0,0,.55);
  }
  .pf-lightbox-emoji { font-size: clamp(120px, 30vw, 320px); line-height: 1; }
  .pf-lightbox p { margin: 0; color: #dbe4ff; font-size: 13px; letter-spacing: .5px; }
  .pf-hero-info { flex: 1; min-width: 0; padding-top: 4px; }
  .pf-name-row { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .pf-name-row h1 { font-size: 30px; font-weight: 800; letter-spacing: 1px; }
  .pf-vip {
    font-size: 11px; font-weight: 900; letter-spacing: 1px;
    color: #2f1c00; background: linear-gradient(140deg, #ffd166, #f5c86a);
    border-radius: 6px; padding: 2px 8px;
  }
  .pf-edit {
    font-family: var(--font); font-size: 12px; font-weight: 700;
    color: #fff; background: rgba(255, 255, 255, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.4); border-radius: 999px;
    padding: 5px 14px; cursor: pointer;
  }
  .pf-edit:hover { background: rgba(255, 255, 255, 0.26); }
  .pf-account { margin-top: 6px; font-size: 13px; color: rgba(255, 255, 255, 0.7); }
  .pf-sign { margin-top: 6px; font-size: 13.5px; color: rgba(255, 255, 255, 0.85); }

  .pf-stats { display: flex; gap: 34px; margin-top: 16px; }
  .pf-stats div { text-align: center; }
  .pf-stats b {
    display: block; font-size: 20px; font-weight: 800;
    font-variant-numeric: tabular-nums; line-height: 1.2;
    max-width: 120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .pf-stats span { font-size: 12px; color: rgba(255, 255, 255, 0.68); }

  /* ===== 鲨鱼等级卡片 ===== */
  .pf-level-card {
    margin-top: 14px;
    max-width: 460px;
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.22);
    border-radius: 14px;
    padding: 12px 16px;
    backdrop-filter: blur(6px);
  }
  .pf-level-card-top {
    display: flex; align-items: center; gap: 10px; flex-wrap: wrap;
  }
  .pf-level-lv {
    font-size: 15px; font-weight: 900; line-height: 1;
    color: #2f1c00; background: linear-gradient(140deg, #ffd166, #f5c86a);
    border-radius: 8px; padding: 5px 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,.25);
  }
  .pf-level-name {
    font-size: 15px; font-weight: 800; color: #fff; letter-spacing: 1px;
  }
  .pf-level-max {
    font-size: 12px; font-weight: 800; color: #ffd166; margin-left: auto;
  }
  .pf-level-next {
    font-size: 12px; font-weight: 600; color: rgba(255, 255, 255, 0.78); margin-left: auto;
  }
  .pf-level-card-bottom {
    display: flex; align-items: center; justify-content: space-between;
    margin-top: 8px; font-size: 12px; font-weight: 600; color: rgba(255, 255, 255, 0.72);
  }
  .pf-level-pct {
    font-weight: 800; color: #ffd166; font-variant-numeric: tabular-nums;
  }

  /* ===== 鲨鱼等级进度条 ===== */
  .pf-level-bar {
    margin-top: 10px;
    height: 9px;
    width: 100%;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.18);
    overflow: hidden;
  }
  .pf-level-fill {
    height: 100%;
    border-radius: 999px;
    background: linear-gradient(90deg, #67e8f9, #f5c86a);
    transition: width 0.5s ease;
  }

  .pf-actions { display: flex; gap: 12px; margin-top: 18px; }
  .pf-btn {
    font-family: var(--font); font-size: 13.5px; font-weight: 700;
    border-radius: 999px; padding: 9px 24px; cursor: pointer;
    transition: transform .15s ease, filter .15s ease;
  }
  .pf-btn.primary {
    color: #0b7efc; background: #fff;
    border: 0; box-shadow: 0 6px 18px rgba(0, 0, 0, 0.25);
  }
  .pf-btn.primary:hover { filter: brightness(0.97); }
  .pf-btn.ghost {
    color: #fff; background: rgba(255, 255, 255, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.45);
  }
  .pf-btn.ghost:hover { background: rgba(255, 255, 255, 0.24); }
  .pf-btn:active { transform: scale(0.96); }

  /* ================= Tab 栏 ================= */
  .pf-tabs {
    position: sticky; top: 0; z-index: 10;
    display: flex; gap: 8px;
    padding: 0 max(30px, calc((100vw - 1200px) / 2));
    height: 52px;
    background: #fff;
    border-bottom: 1px solid #e6eefb;
  }
  .pf-tabs button {
    font-family: var(--font); font-size: 14px; font-weight: 600;
    color: #4a5568; background: none; border: 0; cursor: pointer;
    padding: 0 20px; position: relative;
  }
  .pf-tabs button:hover { color: #0b7efc; }
  .pf-tabs button.on { color: #0b7efc; font-weight: 800; }
  .pf-tabs button.on::after {
    content: ''; position: absolute; left: 20px; right: 20px; bottom: -1px;
    height: 3px; border-radius: 2px; background: #0b7efc;
  }

  /* ================= 主体 ================= */
  .pf-body {
    max-width: 1200px;
    margin: 0 auto;
    padding: 24px 34px;
    display: grid;
    grid-template-columns: 1fr 300px;
    gap: 24px;
  }
  .pf-main { min-width: 0; }
  .pf-side { display: flex; flex-direction: column; gap: 24px; }

  .pf-block {
    background: #fff;
    border: 1px solid #e6eefb;
    border-radius: 16px;
    padding: 20px;
  }
  .pf-block.side { padding: 16px; }
  .pf-block-title {
    font-size: 16px; font-weight: 800; color: var(--ink);
    margin-bottom: 14px; display: flex; align-items: center; gap: 8px;
  }
  .pf-block-title em {
    font-style: normal; font-size: 12px; font-weight: 700;
    color: #8a94a6;
  }
  .pf-block-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 4px; }
  .pf-block-head .pf-block-title { margin-bottom: 14px; }
  .pf-create-btn {
    font-family: var(--font); font-size: 12.5px; font-weight: 800; color: #fff;
    background: linear-gradient(140deg, #0b7efc, #0a6ce0);
    border: 0; border-radius: 999px; padding: 7px 14px; cursor: pointer;
    box-shadow: 0 4px 12px rgba(11,126,252,.3);
    transition: transform .12s ease;
  }
  .pf-create-btn:hover { transform: translateY(-1px); }
  .pf-create-btn:active { transform: scale(.96); }

  /* ===== 动态：发布框 ===== */
  .pf-publish {
    background: #f7faff; border: 1px solid #e4ecfa; border-radius: 16px;
    padding: 14px 16px; margin-bottom: 18px;
  }
  .pf-publish-input {
    width: 100%; box-sizing: border-box; resize: vertical; min-height: 72px;
    border: 1px solid #dbe5f5; border-radius: 12px; padding: 11px 13px;
    font-size: 13.5px; font-family: inherit; color: #2d3748; outline: none;
    background: #fff; line-height: 1.6;
  }
  .pf-publish-input:focus { border-color: #7fa9e2; box-shadow: 0 0 0 3px rgba(127,169,226,.16); }
  .pf-publish-bar {
    display: flex; align-items: center; justify-content: space-between; margin-top: 10px;
  }
  .pf-publish-count { font-size: 12px; color: #9aa5b5; }
  .pf-publish-btn {
    border: 0; border-radius: 999px; padding: 9px 22px; font-size: 13px; font-weight: 800;
    color: #fff; background: linear-gradient(135deg, #0b7efc, #0b4a9c); cursor: pointer;
    box-shadow: 0 4px 12px rgba(11,126,252,.25);
  }
  .pf-publish-btn:hover { filter: brightness(1.06); }
  .pf-publish-btn:disabled { opacity: .6; cursor: default; }

  /* ===== 动态 ===== */
  .pf-moment-list .pf-moment {
    display: flex; gap: 14px; align-items: flex-start;
    padding: 14px 0;
    border-bottom: 1px solid #f0f4fa;
  }
  .pf-moment-list .pf-moment:last-child { border-bottom: 0; }
  .pf-moment-ico {
    flex: none; width: 44px; height: 44px; border-radius: 12px;
    background: #eef5ff; display: grid; place-items: center; font-size: 22px;
  }
  .pf-moment-body { flex: 1; min-width: 0; }
  .pf-moment-body p { font-size: 13.5px; color: #2d3748; line-height: 1.6; word-break: break-word; }
  .pf-moment-time { font-size: 12px; color: #9aa5b5; margin-top: 4px; display: block; }
  .pf-moment-ops { flex: none; display: flex; align-items: center; gap: 4px; }
  .pf-moment-like {
    display: inline-flex; align-items: center; gap: 4px;
    border: 1px solid #f0d5da; background: #fff; border-radius: 999px;
    padding: 5px 10px; font-size: 12px; cursor: pointer; color: #b06;
    transition: background .15s, transform .15s;
  }
  .pf-moment-like span { color: #9aa5b5; font-weight: 700; }
  .pf-moment-like:hover { background: #fff0f3; transform: translateY(-1px); }
  .pf-moment-like.on { background: #ffe9ee; border-color: #ffb3c1; }
  .pf-moment-del {
    flex: none; border: 0; background: transparent; cursor: pointer;
    font-size: 15px; opacity: .35; padding: 6px; border-radius: 8px;
  }
  .pf-moment-del:hover { opacity: 1; background: #ffe9ec; }

  /* ===== 歌单卡片 ===== */
  .pf-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
  }
  .pf-card {
    cursor: pointer; border-radius: 12px; overflow: hidden;
    border: 1px solid #e6eefb;
    transition: transform .18s ease, box-shadow .18s ease;
  }
  .pf-card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(11, 126, 252, 0.14); }
  .pf-card-cover {
    height: 110px; display: grid; place-items: center; position: relative;
  }
  .pf-card-cover.p1 { background: linear-gradient(135deg, #1e293b, #475569); }
  .pf-card-cover.p2 { background: linear-gradient(135deg, #f97316, #fdba74); }
  .pf-card-cover.p3 { background: linear-gradient(135deg, #0e7490, #67e8f9); }
  .pf-card-cover.p4 { background: linear-gradient(135deg, #db2777, #f9a8d4); }
  .pf-card-cover.p5 { background: linear-gradient(135deg, #7c2d12, #f59e0b); }
  .pf-card-cover.p6 { background: linear-gradient(135deg, #b91c1c, #fca5a5); }
  .pf-card-cover.p7 { background: linear-gradient(135deg, #166534, #86efac); }
  .pf-card-cover.p8 { background: linear-gradient(135deg, #312e81, #a5b4fc); }
  .pf-card-icon { font-size: 34px; filter: drop-shadow(0 3px 6px rgba(0,0,0,.3)); }
  .pf-card-plays {
    position: absolute; top: 8px; right: 10px;
    font-size: 11px; font-weight: 700; color: #fff; text-shadow: 0 1px 2px rgba(0,0,0,.45);
  }
  .pf-card-info { padding: 10px 12px; display: flex; flex-direction: column; gap: 3px; }
  .pf-card-info b {
    font-size: 13px; font-weight: 700; color: var(--ink);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .pf-card-info span { font-size: 11.5px; color: #8a94a6; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .pf-card-ops { display: flex; gap: 10px; margin-top: 2px; }
  .pf-card-ops button {
    font-family: var(--font); font-size: 11.5px; font-weight: 700;
    border: 0; background: none; padding: 0; cursor: pointer; color: #0b7efc;
  }
  .pf-card-ops button:hover { text-decoration: underline; }
  .pf-card-ops button.del { color: #ef4444; }

  /* ===== 歌曲列表 ===== */
  .pf-songlist { display: flex; flex-direction: column; }
  .pf-song {
    display: flex; align-items: center; gap: 12px;
    padding: 10px 10px; border-radius: 10px; cursor: pointer;
    transition: background .15s ease;
  }
  .pf-song:hover { background: #f4f9ff; }
  .pf-song.playing { background: #e8f1ff; }
  .pf-song.playing .pf-song-meta b { color: #0b7efc; }
  .pf-song-idx {
    flex: none; width: 22px; text-align: center;
    font-size: 14px; font-weight: 800; color: #9aa5b5; font-variant-numeric: tabular-nums;
  }
  .pf-song-idx.top { color: #f97316; }
  .pf-song-idx.on { color: #0b7efc; font-size: 17px; }
  .pf-song-meta { flex: 1; min-width: 0; }
  .pf-song-meta b {
    display: block; font-size: 13.5px; font-weight: 700; color: #2d3748;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .pf-song-meta span { font-size: 12px; color: #8a94a6; }
  .pf-song-dur, .pf-song-plays { flex: none; font-size: 12px; color: #9aa5b5; font-variant-numeric: tabular-nums; }

  /* ===== 侧边栏 ===== */
  .pf-side-item {
    display: flex; align-items: center; gap: 10px;
    padding: 9px 8px; border-radius: 10px; text-decoration: none;
    transition: background .15s ease;
  }
  .pf-side-item:hover { background: #f4f9ff; }
  .pf-side-cover {
    flex: none; width: 38px; height: 38px; border-radius: 8px;
    display: grid; place-items: center; font-size: 18px;
  }
  .pf-side-cover.p1 { background: linear-gradient(135deg, #1e293b, #475569); }
  .pf-side-cover.p2 { background: linear-gradient(135deg, #f97316, #fdba74); }
  .pf-side-cover.p3 { background: linear-gradient(135deg, #0e7490, #67e8f9); }
  .pf-side-cover.p4 { background: linear-gradient(135deg, #db2777, #f9a8d4); }
  .pf-side-cover.p5 { background: linear-gradient(135deg, #7c2d12, #f59e0b); }
  .pf-side-cover.p6 { background: linear-gradient(135deg, #b91c1c, #fca5a5); }
  .pf-side-cover.p7 { background: linear-gradient(135deg, #166534, #86efac); }
  .pf-side-cover.p8 { background: linear-gradient(135deg, #312e81, #a5b4fc); }
  .pf-side-rank {
    flex: none; width: 20px; text-align: center;
    font-size: 13px; font-weight: 800; color: #9aa5b5; font-variant-numeric: tabular-nums;
  }
  .pf-side-rank.top { color: #f97316; }
  .pf-side-name {
    flex: 1; min-width: 0; font-size: 13px; font-weight: 600; color: #2d3748;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .pf-side-count { flex: none; font-size: 11px; color: #b3bcc9; }

  /* ===== 空状态 ===== */
  .pf-empty {
    padding: 36px 20px; text-align: center;
    font-size: 13px; font-weight: 600; color: #8a94a6;
    border: 2px dashed #cfddf0; border-radius: 12px;
  }
  .pf-empty.slim { padding: 20px 12px; }

  /* ===== 收藏按钮 ===== */
  .pf-fav-btn {
    flex: none;
    width: 34px; height: 34px;
    font-size: 16px; line-height: 1;
    color: #b3bcc9;
    background: none;
    border: 0; border-radius: 50%;
    cursor: pointer;
    transition: color .15s ease, background .15s ease, transform .15s ease;
  }
  .pf-fav-btn:hover { background: #fef0f2; transform: scale(1.08); }
  .pf-fav-btn.on { color: #e03131; }

  /* ===== 关注/粉丝用户列表 ===== */
  .pf-userlist { display: flex; flex-direction: column; }
  .pf-user {
    display: flex; align-items: center; gap: 12px;
    padding: 10px 8px; border-radius: 10px;
    transition: background .15s ease;
  }
  .pf-user:hover { background: #f4f9ff; }
  .pf-user-ava {
    flex: none; width: 42px; height: 42px; border-radius: 50%;
    background: linear-gradient(150deg, var(--shark-blue), var(--shark-blue-deep));
    display: grid; place-items: center;
    font-size: 16px; font-weight: 800; color: #fff;
    overflow: hidden; user-select: none;
  }
  .pf-user-ava.zoomable { cursor: zoom-in; }
  .pf-user-ava img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; display: block; }
  .pf-user-name {
    flex: 1; min-width: 0; font-size: 14px; font-weight: 700; color: var(--ink);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .pf-user-mid { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 2px; }
  .pf-user-uid { font-size: 11px; color: #9aa5b5; font-variant-numeric: tabular-nums; }

  /* ===== 听歌统计 ===== */
  .pf-stat-cell {
    flex: none; min-width: 64px; text-align: right;
    font-size: 12px; color: #9aa5b5; font-variant-numeric: tabular-nums;
  }
  .pf-stat-cell.strong { color: #0b7efc; font-weight: 800; }

  .pf-block-hint { font-size: 12px; color: #9aa5b5; margin: -6px 0 12px; }

  /* ===== 编辑资料弹窗 ===== */
  .pf-edit-modal { width: min(420px, 100%); }
  .pf-edit-label {
    display: block; font-size: 13px; font-weight: 700; color: #4a5568;
    margin: 14px 0 8px;
  }
  .pf-avatar-picker {
    display: flex; flex-wrap: wrap; gap: 8px;
  }
  .pf-avatar-opt {
    width: 44px; height: 44px; font-size: 22px;
    display: grid; place-items: center;
    background: #f4f8ff; border: 2px solid transparent; border-radius: 12px;
    cursor: pointer; transition: all .12s ease;
  }
  .pf-avatar-opt:hover { transform: scale(1.08); background: #eef5ff; }
  .pf-avatar-opt.on { border-color: #0b7efc; background: #e6f0ff; box-shadow: 0 0 0 3px rgba(11,126,252,.18); }
  .pf-avatar-editor { display: flex; gap: 12px; align-items: flex-start; }
  .pf-avatar-preview {
    flex: none; width: 64px; height: 64px; border-radius: 16px;
    display: grid; place-items: center; overflow: hidden;
    background: linear-gradient(150deg, var(--pink-soft), var(--pink));
    border: 2px solid #fff; box-shadow: 0 2px 8px rgba(0,0,0,.12);
    font-size: 30px; font-weight: 800; color: var(--ink);
  }
  .pf-avatar-preview img { width: 100%; height: 100%; object-fit: cover; display: block; }
  .pf-avatar-editor-side { flex: 1; min-width: 0; }
  .pf-avatar-actions { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px; }
  .pf-avatar-action {
    font-family: var(--font); font-size: 12px; font-weight: 700;
    color: #0b6ecc; background: #eef5ff;
    border: 1px solid #cfe1fb; border-radius: 8px;
    padding: 6px 12px; cursor: pointer; white-space: nowrap;
    transition: background .15s ease;
  }
  .pf-avatar-action:hover { background: #dceaff; }
  .pf-hidden-file { display: none; }
  .pf-url-row { display: flex; gap: 8px; align-items: center; }
  .pf-url-row .pf-modal-input { flex: 1; min-width: 0; }
  .pf-avatar-tip { margin: 6px 0 0; font-size: 12px; color: #8a94a6; }
  .pf-user-btn {
    flex: none;
    font-family: var(--font); font-size: 12px; font-weight: 700;
    color: #8a94a6; background: #f4f8ff;
    border: 1px solid #e6eefb; border-radius: 999px;
    padding: 5px 14px; cursor: pointer;
    transition: background .15s ease, color .15s ease;
  }
  .pf-user-btn:hover { background: #fef0f2; color: #e03131; border-color: #f7d4d4; }

  /* ===== 头像框选裁剪弹窗 ===== */
  .crop-mask { z-index: 120; }
  .pf-crop-modal { width: min(540px, 100%); }
  .pf-crop-tip { font-size: 12.5px; color: var(--ink-soft); line-height: 1.6; margin: -6px 0 14px; }
  .pf-crop-stage {
    display: grid; place-items: center;
    background: #0d1526; border-radius: 14px; padding: 12px;
    overflow: auto; max-height: 56vh;
  }
  .pf-crop-canvas {
    display: block; max-width: 100%; max-height: 50vh;
    touch-action: none; cursor: crosshair; border-radius: 6px;
  }

  /* ===== 歌单新建/重命名弹窗 ===== */
  .pf-mask {
    position: fixed; inset: 0; z-index: 80;
    background: rgba(15, 23, 42, 0.45);
    display: grid; place-items: center; padding: 20px;
  }
  .pf-modal {
    width: min(380px, 100%);
    background: #fff; border: 3px solid var(--ink); border-radius: 20px;
    box-shadow: 8px 8px 0 rgba(47,50,56,.9);
    padding: 24px 22px 20px;
  }
  .pf-modal h3 { font-size: 18px; font-weight: 800; margin-bottom: 16px; }
  .pf-modal-input {
    font-family: var(--font); font-size: 14px; font-weight: 600; color: var(--ink);
    width: 100%; border: 2.5px solid var(--ink); border-radius: 12px;
    padding: 11px 13px; background: #fff; outline: 0;
  }
  .pf-modal-input:focus { background: #f7fbff; box-shadow: 3px 3px 0 var(--shark-blue); }
  .pf-modal-foot { display: flex; justify-content: flex-end; gap: 10px; margin-top: 18px; }
  .pf-modal-cancel, .pf-modal-ok {
    font-family: var(--font); font-size: 14px; font-weight: 800;
    border: 2.5px solid var(--ink); border-radius: 12px; padding: 9px 20px; cursor: pointer;
  }
  .pf-modal-cancel { background: #fff; color: var(--ink); box-shadow: 3px 3px 0 var(--ink); }
  .pf-modal-cancel:hover { background: #f1f4f8; }
  .pf-modal-ok { background: linear-gradient(140deg, #0b7efc, #0a6ce0); color: #fff; box-shadow: 3px 3px 0 var(--ink); }
  .pf-modal-ok:hover { filter: brightness(1.05); }

  @media (max-width: 940px) {
    .pf-hero { height: auto; }
    .pf-hero-main { flex-direction: column; padding: 56px 22px 24px; }
    .pf-avatar { width: 100px; height: 100px; font-size: 44px; }
    .pf-body { grid-template-columns: 1fr; padding: 20px; }
    .pf-side { flex-direction: row; flex-wrap: wrap; }
    .pf-side .pf-block { flex: 1; min-width: 240px; }
    .pf-cards { grid-template-columns: repeat(2, 1fr); }
  }
</style>
