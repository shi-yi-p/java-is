<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'

/* 后端接口地址（沿用登录页约定） */
const API = 'http://localhost:8081'

const account = ref('')
const nickname = ref('')
const keyword = ref('')
const toastMsg = ref('')
let toastTimer = null

function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}

/* ============ 已登录用户信息：沿用既有后端接口 GET /api/me ============ */
onMounted(async () => {
  let token = ''
  try { token = localStorage.getItem('shark_token') || '' } catch (e) {}
  if (!token) return
  try {
    const res = await fetch(API + '/api/me', {
      headers: { Authorization: 'Bearer ' + token }
    })
    if (res.status === 401) {
      try { localStorage.removeItem('shark_token') } catch (e) {}
      location.hash = '#/login'
      return
    }
    const data = await res.json().catch(() => ({}))
    if (res.ok && data.data) {
      account.value = data.data.account || ''
      nickname.value = data.data.nickname || data.data.account || '鲨鲨乐迷'
    }
  } catch (e) {
    toast('无法连接服务器 (8081)，请确认后端已启动 🔌')
  }
})

const helloName = computed(() => nickname.value || '鲨鲨乐迷')

/* ============ 顶栏 / 导航 ============ */
const topLinks = ['音乐人', '声播创作', 'VIP会员']
const navItems = ['首页', '榜单', '听书', '直播', '下载鲨鱼', '商务合作', '更多']
const activeNav = ref('首页')

/* ============ Banner 轮播（纯样式占位，后续接后端数据） ============ */
const banners = [
  { title: '深海新歌 · 全网首发', sub: '鲨鱼音乐 KU 剧上新', tone: 'b1' },
  { title: '潮汐 LIVE 现场', sub: '热门歌手巡回直播', tone: 'b2' },
  { title: '夏日冲浪歌单', sub: '每周精选 · 持续更新', tone: 'b3' }
]
const activeBanner = ref(0)
let bannerTimer = null
onMounted(() => {
  bannerTimer = setInterval(() => {
    activeBanner.value = (activeBanner.value + 1) % banners.length
  }, 4000)
})
onUnmounted(() => { if (bannerTimer) clearInterval(bannerTimer) })

/* ============ 内容数据 ============
 * 已接入接口：
 *   GET /api/home/playlists       精选歌单
 *   GET /api/home/charts          热门榜单（含榜单歌曲）
 *   GET /api/home/audiobooks?tab= 听书精选（热门/小说/儿童/相声/情感）
 *   GET /api/home/channels        热门频道
 *   GET /api/home/singers?tab=    热门歌手（华语/欧美/日韩）
 * ============================================================ */
const playlists = ref([])                                  /* 精选歌单 */
const charts = ref([])                                     /* 热门榜单 */
const bookTabs = ['热门', '小说', '儿童', '相声', '情感']
const activeBookTab = ref('热门')
const audiobooks = ref([])                                 /* 听书精选 */
const channels = ref([])                                   /* 热门频道 */
const singerTabs = ['华语', '欧美', '日韩']
const activeSingerTab = ref('华语')
const singers = ref([])                                    /* 热门歌手 */

/* ============ 精选歌单 + 热门榜单：加载后端数据 ============ */
async function loadHome() {
  const EMPTY = { code: 0, data: null }
  try {
    const [pRes, cRes] = await Promise.all([
      fetch(API + '/api/home/playlists'),
      fetch(API + '/api/home/charts')
    ])
    const p = await pRes.json().catch(() => EMPTY)
    const c = await cRes.json().catch(() => EMPTY)
    if (pRes.ok && Array.isArray(p.data)) playlists.value = p.data
    if (cRes.ok && Array.isArray(c.data)) charts.value = c.data
  } catch (e) {
    toast('首页内容加载失败，请确认后端已启动 🔌')
  }
}
onMounted(loadHome)

/* ============ 听书精选：按分类 tab 拉取 ============ */
async function loadAudiobooks(tab) {
  try {
    const res = await fetch(API + '/api/home/audiobooks?tab=' + encodeURIComponent(tab || ''))
    const d = await res.json().catch(() => ({}))
    audiobooks.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    audiobooks.value = []
  }
}
onMounted(() => loadAudiobooks(activeBookTab.value))
watch(activeBookTab, loadAudiobooks)

/* ============ 热门频道：一次性拉取 ============ */
async function loadChannels() {
  try {
    const res = await fetch(API + '/api/home/channels')
    const d = await res.json().catch(() => ({}))
    channels.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    channels.value = []
  }
}
onMounted(loadChannels)

/* ============ 热门歌手：按地区 tab 拉取 ============ */
async function loadSingers(tab) {
  try {
    const res = await fetch(API + '/api/home/singers?tab=' + encodeURIComponent(tab || ''))
    const d = await res.json().catch(() => ({}))
    singers.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    singers.value = []
  }
}
onMounted(() => loadSingers(activeSingerTab.value))
watch(activeSingerTab, loadSingers)

/* 播放量格式化：32860000 -> 3286.0万 */
function fmtPlays(n) {
  const v = Number(n) || 0
  if (v >= 100000000) return (v / 100000000).toFixed(1).replace(/\.0$/, '') + '亿'
  if (v >= 10000) return (v / 10000).toFixed(1).replace(/\.0$/, '') + '万'
  return String(v)
}

/* 榜单趋势角标文案 */
const trendMap = { up: '↑', down: '↓', flat: '—', new: '新' }
function trendOf(t) { return trendMap[t] || '—' }

/* ============ 曲库搜索：GET /api/search?keyword= ============ */
const searchResults = ref([])     /* 搜索结果列表 */
const searchState = ref('')      /* '' | loading | done */
const showPanel = ref(false)     /* 下拉面板开关 */

async function doSearch() {
  const kw = keyword.value.trim()
  if (!kw) {
    showPanel.value = false
    return toast('先输入点什么再搜吧 🐟')
  }
  searchState.value = 'loading'
  showPanel.value = true
  try {
    const res = await fetch(API + '/api/search?keyword=' + encodeURIComponent(kw))
    const data = await res.json().catch(() => ({}))
    searchResults.value = (res.ok && Array.isArray(data.data)) ? data.data : []
    searchState.value = 'done'
  } catch (e) {
    showPanel.value = false
    toast('搜索服务连接失败，请确认后端已启动 🔌')
  }
}

/* 点击某条搜索结果：关闭面板并走播放占位 */
function pickSong(s) {
  showPanel.value = false
  playSong(s)
}

/* 标题关键词高亮：把文本切成 普通段/命中段（避免 v-html） */
function segs(text, kw) {
  const t = String(text || '')
  const k = (kw || '').trim()
  if (!k) return [{ t, hl: false }]
  const i = t.toLowerCase().indexOf(k.toLowerCase())
  if (i < 0) return [{ t, hl: false }]
  return [
    { t: t.slice(0, i), hl: false },
    { t: t.slice(i, i + k.length), hl: true },
    { t: t.slice(i + k.length), hl: false }
  ]
}

/* 时长格式化：222 -> "3:42" */
function fmtTime(sec) {
  const v = Number(sec) || 0
  return Math.floor(v / 60) + ':' + String(v % 60).padStart(2, '0')
}

/* ============ 交互占位 ============ */
function coming(name) {
  toast(name + ' 开发中 🚧 敬请期待')
}

/* 歌单 / 榜单歌曲点击（播放器接口预留） */
function openPlaylist(p) {
  toast('歌单《' + p.title + '》详情开发中 🎧')
}

function playSong(s) {
  toast('▶ ' + s.title + ' · ' + s.artist + '（播放器待接入）')
}

function scrollTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function logout() {
  try { localStorage.removeItem('shark_token') } catch (e) {}
  toast('已退出登录，拜拜 👋')
  setTimeout(() => { location.hash = '#/login' }, 400)
}
</script>

<template>
  <main class="home-shell">
    <!-- ================= 顶部蓝条（logo + 搜索 + 入口 + 用户） ================= -->
    <header class="kg-topbar">
      <div class="kg-brand">
        <div class="kg-brand-mark">
          <svg viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 13c0-3.5 3-6 7-6 2 0 3.6.6 5 1.7L20 6v11l-4-2.7C14.6 15.4 13 16 11 16c-4 0-7-1.5-7-3z" fill="rgba(255,255,255,.25)"/>
            <circle cx="8" cy="11.4" r=".9" fill="#ffffff" stroke="none"/>
            <path d="M10.5 14.5c1.4.9 3 .9 4.4 0" />
          </svg>
        </div>
        <b>鲨鱼音乐</b>
      </div>

      <form class="kg-search" @submit.prevent="doSearch">
        <svg viewBox="0 0 24 24" fill="none" stroke="#8fbdf9" stroke-width="2.4" stroke-linecap="round">
          <circle cx="11" cy="11" r="6.5"/><path d="M16.2 16.2L21 21"/>
        </svg>
        <input v-model="keyword" type="text" placeholder="搜索歌曲 / 歌手 / 专辑…" autocomplete="off" />
        <!-- ===== 曲库搜索结果下拉面板 ===== -->
        <div v-if="showPanel" class="kg-search-panel">
          <div class="kg-search-head">
            <span v-if="searchState === 'loading'">正在曲库中搜索「{{ keyword.trim() }}」…</span>
            <span v-else>共找到 {{ searchResults.length }} 首与「{{ keyword.trim() }}」相关的歌曲</span>
            <i class="kg-search-close" @click="showPanel = false">✕</i>
          </div>

          <div v-if="searchState === 'done' && !searchResults.length" class="kg-search-empty">
            没有找到相关歌曲，换个关键词试试 🐟
          </div>

          <div
            v-for="s in searchResults"
            :key="s.id"
            class="kg-search-item"
            @click="pickSong(s)"
          >
            <span class="kg-search-title">
              <template v-for="(g, gi) in segs(s.title, keyword)" :key="gi">
                <b v-if="g.hl" class="kg-search-hl">{{ g.t }}</b>
                <template v-else>{{ g.t }}</template>
              </template>
            </span>
            <span class="kg-search-artist">{{ s.artist }} · {{ s.album }}</span>
            <span class="kg-search-dur">{{ fmtTime(s.duration) }}</span>
          </div>
        </div>
      </form>

      <nav class="kg-toplinks">
        <a v-for="l in topLinks" :key="l" href="#" @click.prevent="coming(l)">{{ l }}</a>
      </nav>

      <div class="kg-user">
        <div class="kg-avatar">{{ helloName.slice(0, 1) }}</div>
        <span class="kg-nick">{{ helloName }}</span>
        <button class="kg-logout" type="button" @click="logout">退出</button>
      </div>
    </header>

    <!-- ================= 二级导航 ================= -->
    <nav class="kg-navbar">
      <a
        v-for="n in navItems"
        :key="n"
        href="#"
        class="kg-nav-item"
        :class="{ active: activeNav === n }"
        @click.prevent="n === '首页' ? (activeNav = '首页') : coming(n)"
      >{{ n }}</a>
    </nav>

    <!-- ================= Banner 轮播 ================= -->
    <section class="kg-banner" :class="banners[activeBanner].tone">
      <div class="kg-banner-text">
        <em>新歌首发</em>
        <h2>{{ banners[activeBanner].title }}</h2>
        <p>{{ banners[activeBanner].sub }}</p>
      </div>
      <div class="kg-banner-dots">
        <i
          v-for="(b, i) in banners"
          :key="i"
          :class="{ on: activeBanner === i }"
          @click="activeBanner = i"
        ></i>
      </div>
    </section>

    <!-- ================= 客户端下载条 ================= -->
    <div class="kg-download">
      <button type="button" @click="coming('下载电脑版')">🖥️ 下载电脑版</button>
      <button type="button" @click="coming('下载 iPhone 版')"> 下载 iPhone 版</button>
      <button type="button" @click="coming('下载 Android 版')">🤖 下载 Android 版</button>
    </div>

    <!-- ================= 精选歌单 + 热门榜单 ================= -->
    <section class="kg-duo">
      <div class="kg-col">
        <h3 class="kg-sec-title">精选歌单<a href="#" @click.prevent="coming('歌单广场')">更多 ›</a></h3>
        <div v-if="playlists.length" class="kg-cards">
          <div
            v-for="p in playlists"
            :key="p.id"
            class="kg-card"
            @click="openPlaylist(p)"
          >
            <div class="kg-card-cover" :class="p.tone">
              <span class="kg-card-icon">{{ p.icon }}</span>
              <span class="kg-card-plays">▶ {{ fmtPlays(p.plays) }}</span>
              <span class="kg-card-hover">▶ 全部播放</span>
            </div>
            <div class="kg-card-info">
              <b class="kg-card-title">{{ p.title }}</b>
              <span class="kg-card-sub">{{ p.subtitle }}</span>
              <em v-if="p.tag" class="kg-card-tag">{{ p.tag }}</em>
            </div>
          </div>
        </div>
        <div v-else class="kg-empty">暂无歌单 · 待接入后端接口 🦈</div>
      </div>

      <div class="kg-col">
        <h3 class="kg-sec-title">热门榜单<a href="#" @click.prevent="coming('排行榜')">更多 ›</a></h3>
        <div v-if="charts.length" class="kg-charts">
          <div v-for="c in charts" :key="c.id" class="kg-chart">
            <div class="kg-chart-head" :class="c.tone">
              {{ c.name }}
              <i class="kg-chart-flag">热门</i>
            </div>
            <ol v-if="c.songs && c.songs.length" class="kg-chart-list">
              <li
                v-for="s in c.songs"
                :key="s.id"
                @click="playSong(s)"
              >
                <span class="kg-rank" :class="{ top: s.rankNo <= 3 }">{{ s.rankNo }}</span>
                <span class="kg-song">
                  <b class="kg-song-title">{{ s.title }}</b>
                  <span class="kg-song-artist"> - {{ s.artist }}</span>
                </span>
                <span class="kg-trend" :class="s.trend">{{ trendOf(s.trend) }}</span>
              </li>
            </ol>
            <div v-else class="kg-empty slim">暂无歌曲数据</div>
          </div>
        </div>
        <div v-else class="kg-empty">暂无榜单 · 待接入后端接口 🦈</div>
      </div>
    </section>

    <!-- ================= 听书精选 ================= -->
    <section class="kg-section">
      <h3 class="kg-sec-title">
        听书精选
        <span class="kg-tabs">
          <button
            v-for="t in bookTabs" :key="t" type="button"
            :class="{ on: activeBookTab === t }"
            @click="activeBookTab = t"
          >{{ t }}</button>
        </span>
        <a href="#" @click.prevent="coming('听书')">更多 ›</a>
      </h3>
      <div v-if="audiobooks.length" class="kg-cards wide">
        <div v-for="b in audiobooks" :key="b.id" class="kg-card" @click="coming('《' + b.title + '》')">
          <div class="kg-card-cover plain" :class="b.tone">
            <span class="kg-card-icon">{{ b.icon }}</span>
            <span class="kg-card-plays">▶ {{ fmtPlays(b.listens) }}</span>
            <span class="kg-card-hover">▶ 立即收听</span>
          </div>
          <div class="kg-card-info">
            <b class="kg-card-title">{{ b.title }}</b>
            <span class="kg-card-sub">{{ b.author }} · {{ b.intro }}</span>
            <em class="kg-card-tag">{{ b.tab }}</em>
          </div>
        </div>
      </div>
      <div v-else class="kg-empty">「{{ activeBookTab }}」分类暂无内容 · 待接入后端接口 📚</div>
    </section>

    <!-- ================= 热门频道 ================= -->
    <section class="kg-section">
      <h3 class="kg-sec-title">热门频道<a href="#" @click.prevent="coming('频道')">更多 ›</a></h3>
      <div v-if="channels.length" class="kg-channels">
        <div v-for="c in channels" :key="c.id" class="kg-channel" @click="coming(c.name)">
          <span class="kg-channel-ico" :class="c.tone">{{ c.icon }}</span>
          <div class="kg-channel-meta">
            <b>{{ c.name }}</b>
            <span>{{ fmtPlays(c.listeners) }} 人在听</span>
          </div>
        </div>
      </div>
      <div v-else class="kg-empty">暂无频道 · 待接入后端接口 📻</div>
    </section>

    <!-- ================= 热门歌手 ================= -->
    <section class="kg-section">
      <h3 class="kg-sec-title">
        热门歌手
        <span class="kg-tabs">
          <button
            v-for="t in singerTabs" :key="t" type="button"
            :class="{ on: activeSingerTab === t }"
            @click="activeSingerTab = t"
          >{{ t }}</button>
        </span>
        <a href="#" @click.prevent="coming('歌手库')">更多 ›</a>
      </h3>
      <div v-if="singers.length" class="kg-singers">
        <div v-for="s in singers" :key="s.id" class="kg-singer" @click="coming(s.name)">
          <span class="kg-singer-ava" :class="s.tone">{{ s.name.slice(0, 1) }}</span>
          <b class="kg-singer-name">{{ s.name }}</b>
          <span class="kg-singer-fans">{{ fmtPlays(s.fans) }} 粉丝</span>
        </div>
      </div>
      <div v-else class="kg-empty">「{{ activeSingerTab }}」歌手暂无数据 · 待接入后端接口 🎤</div>
    </section>

    <footer class="kg-foot">
      <span>🦈 鲨鱼音乐 · 演示项目</span>
      <span>精选歌单 / 热门榜单数据来自本地 MySQL · 更多板块接入中</span>
    </footer>
  </main>

  <!-- ================= 右侧悬浮工具条 ================= -->
  <aside class="kg-float">
    <button type="button" class="coin" @click="coming('领金币')">🧧<span>领金币</span></button>
    <button type="button" @click="coming('下载鲨鱼')">⬇<span>下载鲨鱼</span></button>
    <button type="button" @click="coming('意见反馈')">✎<span>意见反馈</span></button>
    <button type="button" @click="scrollTop">↑<span>返回顶部</span></button>
  </aside>

  <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
</template>

<style>
  /* ===== 首页外壳：铺满全屏（参照酷狗官网），不影响登录页的卡片样式 ===== */
  body:has(.home-shell) {
    padding: 0;
    display: block;
    background: #ffffff;
  }
  .home-shell {
    position: relative;
    z-index: 1;
    width: 100%;
    min-height: 100vh;
    margin: 0;
    background: #ffffff;
    overflow: hidden;
  }

  /* ===== 顶部蓝条 ===== */
  .kg-topbar {
    display: flex;
    align-items: center;
    gap: 28px;
    padding: 0 max(30px, calc((100vw - 1200px) / 2));
    height: 64px;
    background: linear-gradient(90deg, #0b7efc 0%, #0a6ce0 100%);
    color: #fff;
  }
  .kg-brand { display: flex; align-items: center; gap: 10px; flex: none; }
  .kg-brand-mark {
    width: 36px; height: 36px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.18);
    display: grid; place-items: center;
  }
  .kg-brand-mark svg { width: 22px; height: 22px; }
  .kg-brand b { font-size: 19px; letter-spacing: 1px; }

  .kg-search {
    display: flex; align-items: center;
    width: min(320px, 32vw);
    height: 36px;
    background: rgba(255, 255, 255, 0.16);
    border-radius: 999px;
    padding: 0 16px;
    gap: 8px;
  }
  .kg-search svg { width: 17px; height: 17px; flex: none; }
  .kg-search input {
    flex: 1; border: 0; outline: 0; background: transparent; height: 100%;
    font-family: var(--font); font-size: 13px; color: #fff;
  }
  .kg-search input::placeholder { color: rgba(255, 255, 255, 0.65); }

  /* ===== 曲库搜索结果下拉面板 ===== */
  .kg-search { position: relative; }
  .kg-search-panel {
    position: absolute;
    top: 44px; left: 0; right: 0;
    min-width: 320px;
    max-height: 380px;
    overflow-y: auto;
    background: #fff;
    border: 1px solid #e6eefb;
    border-radius: 14px;
    box-shadow: 0 16px 40px rgba(15, 23, 42, 0.18);
    z-index: 50;
  }
  .kg-search-head {
    position: sticky; top: 0;
    display: flex; align-items: center; justify-content: space-between; gap: 10px;
    padding: 10px 14px;
    background: #f8fbff;
    border-bottom: 1px solid #eef2f7;
    font-size: 12px; font-weight: 700; color: #8a94a6;
  }
  .kg-search-close {
    flex: none;
    font-style: normal; cursor: pointer;
    color: #b3bcc9; padding: 0 2px;
  }
  .kg-search-close:hover { color: #2f3238; }
  .kg-search-empty {
    padding: 26px 16px;
    font-size: 13px; font-weight: 600; color: #8a94a6;
    text-align: center;
  }
  .kg-search-item {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 14px;
    cursor: pointer;
  }
  .kg-search-item:hover { background: #f4f9ff; }
  .kg-search-title {
    flex: none; max-width: 45%;
    font-size: 13.5px; font-weight: 700; color: #2f3238;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .kg-search-hl { color: #0b7efc; }
  .kg-search-artist {
    flex: 1; min-width: 0;
    font-size: 12px; color: #8a94a6;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .kg-search-dur {
    flex: none;
    font-size: 12px; color: #b3bcc9;
    font-variant-numeric: tabular-nums;
  }

  .kg-toplinks { display: flex; gap: 22px; margin-left: auto; }
  .kg-toplinks a {
    color: rgba(255, 255, 255, 0.85); font-size: 13px; font-weight: 600;
    text-decoration: none;
  }
  .kg-toplinks a:hover { color: #fff; }

  .kg-user { display: flex; align-items: center; gap: 8px; flex: none; }
  .kg-avatar {
    width: 32px; height: 32px; border-radius: 50%;
    background: linear-gradient(150deg, var(--pink-soft), var(--pink));
    border: 2px solid rgba(255, 255, 255, 0.6);
    display: grid; place-items: center;
    font-size: 13px; font-weight: 800; color: var(--ink);
  }
  .kg-nick { font-size: 13px; max-width: 110px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .kg-logout {
    font-family: var(--font); font-size: 11.5px; font-weight: 700;
    color: #fff; background: rgba(255, 255, 255, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.4); border-radius: 999px;
    padding: 4px 12px; cursor: pointer;
  }
  .kg-logout:hover { background: rgba(255, 255, 255, 0.26); }

  /* ===== 二级导航 ===== */
  .kg-navbar {
    display: flex; align-items: center; gap: 4px;
    padding: 0 max(30px, calc((100vw - 1200px) / 2));
    height: 46px;
    background: #f4f8ff;
    border-bottom: 1px solid #e6eefb;
  }
  .kg-nav-item {
    font-size: 14px; font-weight: 600; color: #4a5568;
    text-decoration: none; padding: 6px 18px; border-radius: 999px;
  }
  .kg-nav-item:hover { color: #0b7efc; }
  .kg-nav-item.active { color: #fff; background: #0b7efc; font-weight: 700; }

  /* ===== Banner 轮播 ===== */
  .kg-banner {
    position: relative;
    height: 300px;
    display: flex; align-items: center;
    padding: 0 max(60px, calc((100vw - 1200px) / 2 + 30px));
    transition: background 0.6s ease;
  }
  .kg-banner.b1 { background: linear-gradient(105deg, #101418 0%, #1d2733 55%, #0b3a75 100%); }
  .kg-banner.b2 { background: linear-gradient(105deg, #101418 0%, #2a1d33 55%, #5b21b6 100%); }
  .kg-banner.b3 { background: linear-gradient(105deg, #101418 0%, #1d3327 55%, #0e7490 100%); }
  .kg-banner-text { color: #fff; }
  .kg-banner-text em {
    font-style: normal; font-size: 12px; letter-spacing: 3px;
    color: #f5c86a; font-weight: 800;
  }
  .kg-banner-text h2 { font-size: 40px; letter-spacing: 6px; margin-top: 8px; }
  .kg-banner-text p { margin-top: 10px; font-size: 14px; color: rgba(255, 255, 255, 0.72); }
  .kg-banner-dots {
    position: absolute; bottom: 18px;
    left: max(60px, calc((100vw - 1200px) / 2 + 30px));
    display: flex; gap: 8px;
  }
  .kg-banner-dots i {
    width: 18px; height: 4px; border-radius: 2px;
    background: rgba(255, 255, 255, 0.35); cursor: pointer;
    transition: background 0.2s ease;
  }
  .kg-banner-dots i.on { background: #fff; }

  /* ===== 客户端下载条 ===== */
  .kg-download {
    display: flex;
    border-bottom: 1px solid #eef2f7;
  }
  .kg-download button {
    flex: 1; height: 46px;
    font-family: var(--font); font-size: 13.5px; font-weight: 600; color: #4a5568;
    background: #fafcff; border: 0; border-right: 1px solid #eef2f7;
    cursor: pointer;
  }
  .kg-download button:last-child { border-right: 0; }
  .kg-download button:hover { background: #eef5ff; color: #0b7efc; }

  /* ===== 内容区通用：居中限宽，顶栏/导航/Banner 全屏铺满 ===== */
  .kg-section, .kg-duo {
    padding: 34px 34px 6px;
    max-width: 1200px;
    margin: 0 auto;
  }
  .kg-duo { display: grid; grid-template-columns: 1.2fr 1fr; gap: 34px; }
  .kg-sec-title {
    font-size: 20px; font-weight: 800; color: var(--ink);
    display: flex; align-items: center; gap: 16px;
  }
  .kg-sec-title > a {
    margin-left: auto;
    font-size: 12.5px; font-weight: 600; color: #8a94a6; text-decoration: none;
  }
  .kg-sec-title > a:hover { color: #0b7efc; }

  .kg-tabs { display: flex; gap: 14px; }
  .kg-tabs button {
    font-family: var(--font); font-size: 13px; font-weight: 600;
    color: #6b7280; background: none; border: 0; cursor: pointer;
    padding: 2px 4px;
  }
  .kg-tabs button.on { color: #0b7efc; font-weight: 800; }
  .kg-tabs button:hover { color: #0b7efc; }

  /* ===== 空状态占位 ===== */
  .kg-empty {
    margin-top: 18px;
    padding: 44px 20px;
    background: #fafcff;
    border: 2px dashed #cfddF0;
    border-radius: 14px;
    font-size: 13.5px; font-weight: 600; color: #8a94a6;
    text-align: center;
  }
  .kg-empty.slim { padding: 24px 12px; margin-top: 0; border-radius: 0 0 12px 12px; }

  /* ===== 精选歌单卡片流 ===== */
  .kg-cards {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
    margin-top: 18px;
  }
  .kg-card {
    border: 1px solid #e6eefb;
    border-radius: 14px;
    overflow: hidden;
    cursor: pointer;
    transition: transform 0.18s ease, box-shadow 0.18s ease;
    background: #fff;
  }
  .kg-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 24px rgba(11, 126, 252, 0.14);
  }

  .kg-card-cover {
    position: relative;
    height: 112px;
    display: grid;
    place-items: center;
    overflow: hidden;
  }
  /* 黑胶唱片：从封面右下角探出，突出歌单的“音乐”属性 */
  .kg-card-cover::before {
    content: '';
    position: absolute;
    right: -40px;
    bottom: -56px;
    width: 152px;
    height: 152px;
    border-radius: 50%;
    background:
      repeating-radial-gradient(circle, rgba(255, 255, 255, 0.16) 0 2px, rgba(255, 255, 255, 0) 2px 5.5px),
      rgba(0, 0, 0, 0.22);
    box-shadow: 0 6px 14px rgba(0, 0, 0, 0.25);
  }
  /* 唱片中心孔 */
  .kg-card-cover::after {
    content: '';
    position: absolute;
    right: 25px;
    bottom: 9px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.9);
    box-shadow: inset 0 0 0 4px rgba(0, 0, 0, 0.18);
  }
  /* 封面渐变：与数据库 playlist.tone 一一对应 */
  .kg-card-cover.p1 { background: linear-gradient(135deg, #1e293b, #334155, #475569); }
  .kg-card-cover.p2 { background: linear-gradient(135deg, #f97316, #fb923c, #fdba74); }
  .kg-card-cover.p3 { background: linear-gradient(135deg, #0e7490, #06b6d4, #67e8f9); }
  .kg-card-cover.p4 { background: linear-gradient(135deg, #db2777, #ec4899, #f9a8d4); }
  .kg-card-cover.p5 { background: linear-gradient(135deg, #7c2d12, #b45309, #f59e0b); }
  .kg-card-cover.p6 { background: linear-gradient(135deg, #b91c1c, #ef4444, #fca5a5); }
  .kg-card-cover.p7 { background: linear-gradient(135deg, #166534, #22c55e, #86efac); }
  .kg-card-cover.p8 { background: linear-gradient(135deg, #312e81, #6366f1, #a5b4fc); }

  .kg-card-icon {
    font-size: 36px;
    filter: drop-shadow(0 3px 6px rgba(0, 0, 0, 0.3));
    margin-right: 44px;      /* 避开右下角探出的唱片 */
    transform: translateY(-8px);
  }
  .kg-card-plays {
    position: absolute; top: 8px; right: 10px;
    font-size: 11px; font-weight: 700; color: #fff;
    text-shadow: 0 1px 2px rgba(0,0,0,.45);
  }
  .kg-card-hover {
    position: absolute; inset: 0;
    z-index: 1;                    /* 盖住唱片与角标，hover 时封面整体压暗 */
    display: grid; place-items: center;
    background: rgba(15, 23, 42, 0.55);
    color: #fff; font-size: 13.5px; font-weight: 700; letter-spacing: 2px;
    opacity: 0;
    transition: opacity 0.18s ease;
  }
  .kg-card:hover .kg-card-hover { opacity: 1; }

  .kg-card-info {
    padding: 10px 12px 12px;
    display: flex; flex-direction: column; gap: 3px;
  }
  .kg-card-title {
    font-size: 13.5px; font-weight: 700; color: var(--ink);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .kg-card-sub {
    font-size: 12px; color: #8a94a6;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .kg-card-tag {
    align-self: flex-start;
    font-style: normal; font-size: 11px; font-weight: 700;
    color: #0b7efc; background: #eef5ff;
    border-radius: 999px; padding: 1px 8px; margin-top: 3px;
  }

  /* 听书等通栏区块用 4 列卡片流（精选歌单在双栏里仍为 2 列） */
  .kg-cards.wide { grid-template-columns: repeat(4, 1fr); }
  .kg-cards.wide .kg-card-sub { white-space: normal; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; line-height: 1.4; }
  /* 听书封面不叠黑胶唱片 */
  .kg-card-cover.plain::before,
  .kg-card-cover.plain::after { display: none; }
  .kg-card-cover.plain .kg-card-icon { margin-right: 0; transform: none; }

  /* ===== 热门频道 ===== */
  .kg-channels {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
    margin-top: 18px;
  }
  .kg-channel {
    display: flex; align-items: center; gap: 12px;
    padding: 14px;
    border: 1px solid #e6eefb; border-radius: 14px;
    background: #fff; cursor: pointer;
    transition: transform 0.18s ease, box-shadow 0.18s ease;
  }
  .kg-channel:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 20px rgba(11, 126, 252, 0.12);
  }
  .kg-channel-ico {
    flex: none;
    width: 44px; height: 44px;
    display: grid; place-items: center;
    font-size: 22px;
    border-radius: 12px;
  }
  .kg-channel-ico.p1 { background: linear-gradient(135deg, #1e293b, #475569); }
  .kg-channel-ico.p2 { background: linear-gradient(135deg, #f97316, #fdba74); }
  .kg-channel-ico.p3 { background: linear-gradient(135deg, #0e7490, #67e8f9); }
  .kg-channel-ico.p4 { background: linear-gradient(135deg, #db2777, #f9a8d4); }
  .kg-channel-ico.p5 { background: linear-gradient(135deg, #b45309, #f59e0b); }
  .kg-channel-ico.p6 { background: linear-gradient(135deg, #b91c1c, #fca5a5); }
  .kg-channel-ico.p7 { background: linear-gradient(135deg, #166534, #86efac); }
  .kg-channel-ico.p8 { background: linear-gradient(135deg, #312e81, #a5b4fc); }
  .kg-channel-meta { display: flex; flex-direction: column; gap: 3px; min-width: 0; }
  .kg-channel-meta b {
    font-size: 14px; font-weight: 700; color: var(--ink);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .kg-channel-meta span { font-size: 12px; color: #8a94a6; }

  /* ===== 热门歌手 ===== */
  .kg-singers {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 16px;
    margin-top: 18px;
  }
  .kg-singer {
    display: flex; flex-direction: column; align-items: center; gap: 6px;
    padding: 18px 10px 14px;
    border: 1px solid #e6eefb; border-radius: 14px;
    background: #fff; cursor: pointer;
    transition: transform 0.18s ease, box-shadow 0.18s ease;
  }
  .kg-singer:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 20px rgba(11, 126, 252, 0.12);
  }
  .kg-singer-ava {
    width: 64px; height: 64px;
    border-radius: 50%;
    display: grid; place-items: center;
    font-size: 24px; font-weight: 800; color: #fff;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.25);
  }
  .kg-singer-ava.p1 { background: linear-gradient(135deg, #1e293b, #475569); }
  .kg-singer-ava.p2 { background: linear-gradient(135deg, #f97316, #fdba74); }
  .kg-singer-ava.p3 { background: linear-gradient(135deg, #0e7490, #67e8f9); }
  .kg-singer-ava.p4 { background: linear-gradient(135deg, #db2777, #f9a8d4); }
  .kg-singer-ava.p5 { background: linear-gradient(135deg, #b45309, #f59e0b); }
  .kg-singer-ava.p6 { background: linear-gradient(135deg, #b91c1c, #fca5a5); }
  .kg-singer-ava.p7 { background: linear-gradient(135deg, #166534, #86efac); }
  .kg-singer-ava.p8 { background: linear-gradient(135deg, #312e81, #a5b4fc); }
  .kg-singer-name {
    font-size: 13.5px; font-weight: 700; color: var(--ink);
    max-width: 100%;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .kg-singer-fans { font-size: 12px; color: #8a94a6; }

  /* ===== 热门榜单块 ===== */
  .kg-charts { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 18px; }
  .kg-chart {
    border: 1px solid #e6eefb; border-radius: 12px; overflow: hidden;
    transition: box-shadow 0.18s ease;
  }
  .kg-chart:hover { box-shadow: 0 10px 20px rgba(11, 126, 252, 0.1); }
  .kg-chart-head {
    position: relative;
    padding: 12px; text-align: center;
    font-size: 15px; font-weight: 800; color: #fff; letter-spacing: 2px;
  }
  .kg-chart-head.orange { background: linear-gradient(140deg, #ff9f43, #f97316); }
  .kg-chart-head.blue   { background: linear-gradient(140deg, #38bdf8, #2563eb); }
  .kg-chart-head.purple { background: linear-gradient(140deg, #c084fc, #7c3aed); }
  .kg-chart-head.teal   { background: linear-gradient(140deg, #2dd4bf, #0d9488); }
  .kg-chart-flag {
    position: absolute; right: 8px; top: 50%;
    transform: translateY(-50%) rotate(8deg);
    font-style: normal; font-size: 10px; font-weight: 900;
    color: #fff; background: rgba(255, 255, 255, 0.25);
    border: 1px solid rgba(255, 255, 255, 0.55);
    border-radius: 4px; padding: 1px 5px; letter-spacing: 1px;
  }

  .kg-chart-list { list-style: none; padding: 8px 14px 10px; }
  .kg-chart-list li {
    display: flex; align-items: center; gap: 10px;
    padding: 7px 6px; border-radius: 8px;
    cursor: pointer;
    transition: background 0.15s ease;
  }
  .kg-chart-list li:hover { background: #f4f9ff; }
  .kg-rank {
    flex: none; width: 18px; text-align: center;
    font-size: 13px; font-weight: 800; color: #9aa5b5;
    font-variant-numeric: tabular-nums;
  }
  .kg-rank.top { color: #f97316; }
  .kg-song {
    flex: 1; min-width: 0;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    font-size: 13px;
  }
  .kg-song-title { font-weight: 600; color: #2d3748; }
  .kg-song-artist { font-size: 12px; color: #8a94a6; }
  .kg-trend {
    flex: none;
    font-size: 12px; font-weight: 800;
    width: 20px; text-align: center;
    font-variant-numeric: tabular-nums;
  }
  .kg-trend.up   { color: #ef4444; }
  .kg-trend.down { color: #10b981; }
  .kg-trend.flat { color: #9aa5b5; }
  .kg-trend.new  {
    color: #d97706; font-size: 10.5px;
    background: #fef3c7; border-radius: 999px; padding: 0 4px;
  }

  /* ===== 右侧悬浮工具条 ===== */
  .kg-float {
    position: fixed; right: 18px; top: 50%;
    transform: translateY(-50%);
    display: flex; flex-direction: column;
    z-index: 10;
    border: var(--stroke) solid var(--ink);
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 4px 4px 0 rgba(47, 50, 56, 0.9);
    background: #fff;
  }
  .kg-float button {
    font-family: var(--font);
    width: 74px; padding: 10px 0;
    background: #fff; border: 0; border-bottom: 1px solid #eef2f7;
    font-size: 17px; cursor: pointer; color: var(--ink);
    display: flex; flex-direction: column; align-items: center; gap: 3px;
  }
  .kg-float button span { font-size: 11px; font-weight: 700; color: #6b7280; }
  .kg-float button:last-child { border-bottom: 0; }
  .kg-float button:hover { background: #eef5ff; }
  .kg-float button.coin { background: linear-gradient(150deg, #ffe9bf, #ffd166); }
  .kg-float button.coin span { color: #8a5a00; }

  /* ===== 页脚 ===== */
  .kg-foot {
    display: flex; justify-content: space-between; flex-wrap: wrap; gap: 8px;
    padding: 24px 34px 28px;
    margin: 28px auto 0;
    max-width: 1200px;
    border-top: 1px solid #eef2f7;
    font-size: 11.5px; font-weight: 700; color: var(--ink-soft);
  }

  @media (max-width: 940px) {
    .kg-topbar { flex-wrap: wrap; height: auto; padding: 12px 20px; gap: 12px; }
    .kg-toplinks { display: none; }
    .kg-search { order: 3; width: 100%; }
    .kg-navbar { padding: 0 16px; overflow-x: auto; }
    .kg-banner { height: 180px; padding: 0 28px; }
    .kg-banner-text h2 { font-size: 28px; }
    .kg-banner-dots { left: 28px; }
    .kg-duo { grid-template-columns: 1fr; }
    .kg-cards.wide { grid-template-columns: repeat(2, 1fr); }
    .kg-channels { grid-template-columns: repeat(2, 1fr); }
    .kg-section, .kg-duo { padding: 24px 20px 4px; }
    .kg-float { display: none; }
  }
  @media (max-width: 480px) {
    .kg-nick { display: none; }
  }
</style>
