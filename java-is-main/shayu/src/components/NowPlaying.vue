<script setup>
/* ============================================================
 * 正在播放（酷狗式全屏详情页）
 * 由 HomeView 的 <NowPlaying v-if="player.open" /> 渲染
 * ============================================================ */
import { player, togglePlay, next, prev, seek, fmtTime, playTrack, cycleMode } from '../player.js'
import { ref, computed, watch, nextTick } from 'vue'

const like = ref(false)
const lyricMode = ref(true)

const percent = computed(() =>
  player.duration ? Math.min(100, (player.cur / player.duration) * 100) : 0
)

function onSeek(e) {
  const rect = e.currentTarget.getBoundingClientRect()
  const ratio = Math.min(1, Math.max(0, (e.clientX - rect.left) / rect.width))
  seek(ratio * (player.duration || 0))
}

function toast(msg) {
  try { window.dispatchEvent(new CustomEvent('shark-toast', { detail: msg })) } catch (e) {}
}

function toggleLike() {
  like.value = !like.value
  toast(like.value ? '已收藏 ❤️' : '已取消收藏')
}

function close() {
  player.open = false
}

/* 播放模式图标 */
const MODE_LABEL = { list: '🔁', one: '🔂', order: '➡️' }
function toggleMode() {
  cycleMode()
  toast('播放模式：' + ({ list: '列表循环', one: '单曲循环', order: '顺序播放' })[player.mode])
}

function playFromQueue(i) {
  const s = player.queue[i]
  if (s) playTrack(s, player.queue)
}

/* ================= 歌词（演示歌词，按歌曲 id 确定性生成） ================= */
const LYRICS_POOL = [
  '晚风把心事吹散在街角',
  '那些没说出口的，都留给海潮',
  '若月亮没来，星星也失眠',
  '把梦折成纸飞机，飞向你的窗',
  '时间慢一点，让我再靠近一点',
  '所有的告别，都是为了更好的重逢',
  '把回忆酿成酒，敬这一路的风',
  '你是我藏在心底，最温柔的秘密',
  '逆着风奔跑，也要拥抱明天',
  '这世界很大，还好我们相遇',
  '萤火照亮了夏夜，也照亮了想念',
  '愿你被这世界，温柔以待'
]

/* 根据歌曲 id 生成确定性的歌词行（同一首歌每次一致） */
const lyrics = computed(() => {
  const s = player.song
  if (!s) return []
  const seed = Number(s.id) || 1
  const total = player.duration || Number(s.duration) || 240
  // 行数：6 ~ 8 行
  const count = 6 + (seed % 3)
  const lines = []
  for (let i = 0; i < count; i++) {
    const poolIdx = (seed + i * 3) % LYRICS_POOL.length
    lines.push({ t: (total / count) * i, text: LYRICS_POOL[poolIdx] })
  }
  return lines
})

/* 当前高亮歌词下标 */
const curLyricIdx = computed(() => {
  if (!lyrics.value.length) return -1
  const cur = player.cur || 0
  let idx = -1
  for (let i = 0; i < lyrics.value.length; i++) {
    if (cur >= lyrics.value[i].t) idx = i
  }
  return idx
})

/* 歌词滚动容器，自动滚动到当前高亮行 */
const lyricScrollEl = ref(null)
watch(curLyricIdx, (idx) => {
  if (idx < 0 || !lyricScrollEl.value) return
  nextTick(() => {
    const lines = lyricScrollEl.value.querySelectorAll('.np-lyric-line')
    const el = lines[idx]
    if (el) {
      const c = lyricScrollEl.value
      const top = el.offsetTop - c.clientHeight / 2 + el.clientHeight / 2
      c.scrollTo({ top, behavior: 'smooth' })
    }
  })
})

/* ================= 波形动画（播放时跳动，暂停时静止） ================= */
const WAVE_BARS = 28
const waveBars = computed(() => {
  const playing = player.playing
  const seed = Number(player.song?.id) || 1
  const bars = []
  for (let i = 0; i < WAVE_BARS; i++) {
    // 确定性伪随机高度基准 + 播放时随时间抖动
    const base = 20 + ((seed * 31 + i * 17) % 80)
    bars.push({ base })
  }
  return bars
})

</script>

<template>
  <div class="np-shell">
    <!-- 背景光斑 -->
    <div class="np-glow g1"></div>
    <div class="np-glow g2"></div>

    <!-- 顶部 -->
    <header class="np-head">
      <button class="np-down" type="button" title="收起" @click="close">⌄</button>
      <div class="np-head-center">
        <em>正在播放</em>
        <b>{{ player.song ? player.song.title : '未在播放' }}</b>
      </div>
      <button class="np-like" :class="{ on: like }" type="button" title="收藏" @click="toggleLike">
        {{ like ? '❤️' : '🤍' }}
      </button>
    </header>

    <div v-if="player.song" class="np-body">
      <!-- 黑胶唱片 -->
      <div class="np-disc-wrap">
        <div class="np-disc" :class="{ spin: player.playing }">
          <span class="np-disc-cover">🎧</span>
        </div>
        <div class="np-arms"></div>
      </div>

      <!-- 波形动画 -->
      <div class="np-wave">
        <span
          v-for="(b, i) in waveBars"
          :key="i"
          class="np-wave-bar"
          :class="{ on: player.playing }"
          :style="{ height: b.base + 'px' }"
        ></span>
      </div>

      <!-- 歌词滚动 -->
      <div v-if="lyricMode && lyrics.length" class="np-lyric">
        <div class="np-lyric-scroll" ref="lyricScrollEl">
          <p
            v-for="(l, i) in lyrics"
            :key="i"
            class="np-lyric-line"
            :class="{ on: i === curLyricIdx }"
          >{{ l.text }}</p>
        </div>
      </div>

      <!-- 歌曲信息 -->
      <div class="np-song-info">
        <h2 class="np-title">{{ player.song.title }}</h2>
        <p class="np-artist">
          歌手：{{ player.song.artist }}
          <span class="np-sep">|</span>
          专辑：{{ player.song.album }}
        </p>
        <p class="np-tip" v-if="!player.playing">点击播放按钮开始试听（无音源时仅为演示）</p>
      </div>

      <!-- 进度条 -->
      <div class="np-progress">
        <span class="np-time">{{ fmtTime(player.cur) }}</span>
        <div class="np-track" @click="onSeek">
          <div class="np-track-fill" :style="{ width: percent + '%' }"></div>
        </div>
        <span class="np-time">{{ fmtTime(player.duration) }}</span>
      </div>

      <!-- 控制按钮 -->
      <div class="np-ctrl">
        <button class="np-ctrl-btn" type="button" @click="like = !like; toggleLike()">♡</button>
        <button class="np-ctrl-btn skip" type="button" title="上一首" @click="prev">⏮</button>
        <button class="np-ctrl-btn main" type="button" @click="togglePlay">
          {{ player.playing ? '⏸' : '▶' }}
        </button>
        <button class="np-ctrl-btn skip" type="button" title="下一首" @click="next">⏭</button>
        <button class="np-ctrl-btn" type="button" :class="{ on: player.mode === 'one' }" title="播放模式" @click="toggleMode">{{ MODE_LABEL[player.mode] }}</button>
        <button class="np-ctrl-btn" type="button" :class="{ on: lyricMode }" @click="lyricMode = !lyricMode">词</button>
      </div>

      <!-- 播放队列 -->
      <div class="np-queue" v-if="player.queue.length > 1">
        <h3 class="np-queue-title">播放队列（{{ player.queue.length }}）</h3>
        <ol class="np-queue-list">
          <li
            v-for="(s, i) in player.queue"
            :key="s.id"
            :class="{ on: i === player.index }"
            @click="playFromQueue(i)"
          >
            <span class="np-queue-no">{{ i + 1 }}</span>
            <b class="np-queue-name">{{ s.title }}</b>
            <span class="np-queue-artist">{{ s.artist }}</span>
          </li>
        </ol>
      </div>
    </div>

    <div v-else class="np-empty">
      <p>还没有播放任何歌曲 🎵</p>
      <button type="button" @click="close">去首页挑一首</button>
    </div>
  </div>
</template>

<style>
  .np-shell {
    position: relative;
    z-index: 1;
    min-height: calc(100vh - 110px);
    background: linear-gradient(160deg, #0c1220 0%, #12203a 45%, #0b3a75 100%);
    color: #fff;
    overflow: hidden;
    padding: 20px max(34px, calc((100vw - 900px) / 2)) 40px;
  }
  .np-glow {
    position: absolute;
    border-radius: 50%;
    filter: blur(90px);
    opacity: 0.35;
    pointer-events: none;
  }
  .np-glow.g1 { width: 420px; height: 420px; background: #0b7efc; top: -140px; left: -120px; }
  .np-glow.g2 { width: 360px; height: 360px; background: #7c3aed; bottom: -120px; right: -100px; }

  .np-head {
    position: relative; z-index: 1;
    display: flex; align-items: center; justify-content: space-between;
    max-width: 900px; margin: 0 auto;
  }
  .np-down, .np-like {
    font-family: inherit;
    width: 40px; height: 40px;
    border: 1px solid rgba(255,255,255,0.22);
    border-radius: 50%;
    background: rgba(255,255,255,0.08);
    color: #fff; font-size: 18px;
    cursor: pointer;
    transition: background 0.15s ease;
  }
  .np-down:hover, .np-like:hover { background: rgba(255,255,255,0.2); }
  .np-like.on { background: rgba(239,68,68,0.35); border-color: rgba(239,68,68,0.6); }
  .np-head-center { text-align: center; }
  .np-head-center em {
    font-style: normal;
    display: block;
    font-size: 10.5px; font-weight: 800; letter-spacing: 3px;
    color: rgba(255,255,255,0.5);
  }
  .np-head-center b {
    font-size: 15px; font-weight: 700;
    max-width: 40vw;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    display: block;
  }

  .np-body { position: relative; z-index: 1; max-width: 640px; margin: 0 auto; }

  .np-disc-wrap { position: relative; display: grid; place-items: center; margin-top: 30px; }
  .np-disc {
    width: 230px; height: 230px;
    border-radius: 50%;
    background:
      repeating-radial-gradient(circle, rgba(255,255,255,0.08) 0 2px, rgba(255,255,255,0) 2px 6px),
      radial-gradient(circle at 35% 30%, #2a3b57, #0a0f1a 70%);
    box-shadow: 0 24px 60px -18px rgba(0,0,0,0.8), inset 0 0 0 6px rgba(255,255,255,0.05);
    display: grid; place-items: center;
  }
  .np-disc.spin { animation: npSpin 5s linear infinite; }
  @keyframes npSpin { to { transform: rotate(360deg); } }
  .np-disc-cover {
    width: 96px; height: 96px;
    border-radius: 50%;
    background: linear-gradient(140deg, #4fa3ff, #0b7efc 55%, #7c3aed);
    display: grid; place-items: center;
    font-size: 40px;
    box-shadow: inset 0 0 0 5px rgba(255,255,255,0.25);
  }
  .np-arms {
    position: absolute;
    top: -6px; right: calc(50% - 130px);
    width: 4px; height: 110px;
    background: linear-gradient(#e5e7eb, #9ca3af);
    border-radius: 2px;
    transform: rotate(28deg);
    transform-origin: top center;
    box-shadow: 0 4px 10px rgba(0,0,0,0.4);
  }

  .np-song-info { text-align: center; margin-top: 30px; }
  .np-title { font-size: 26px; font-weight: 800; letter-spacing: 1px; }
  .np-artist { margin-top: 8px; font-size: 13px; color: rgba(255,255,255,0.65); }
  .np-sep { margin: 0 10px; opacity: 0.4; }
  .np-tip { margin-top: 8px; font-size: 11.5px; color: rgba(255,255,255,0.4); }

  /* ===== 波形动画 ===== */
  .np-wave {
    display: flex; align-items: flex-end; justify-content: center;
    gap: 3px;
    height: 100px;
    margin-top: 24px;
  }
  .np-wave-bar {
    flex: none;
    width: 4px;
    border-radius: 2px;
    background: linear-gradient(180deg, #67e8f9, #0b7efc);
    opacity: 0.35;
    transition: height 0.3s ease, opacity 0.3s ease;
  }
  .np-wave-bar.on {
    opacity: 0.95;
    animation: npWave 0.9s ease-in-out infinite alternate;
  }
  .np-wave-bar.on:nth-child(odd) { animation-duration: 0.7s; }
  .np-wave-bar.on:nth-child(3n) { animation-duration: 1.1s; }
  .np-wave-bar.on:nth-child(4n) { animation-duration: 0.55s; }
  @keyframes npWave {
    from { transform: scaleY(0.4); }
    to { transform: scaleY(1.15); }
  }

  /* ===== 歌词滚动 ===== */
  .np-lyric {
    margin-top: 24px;
    max-width: 640px;
    margin-left: auto; margin-right: auto;
  }
  .np-lyric-scroll {
    max-height: 220px;
    overflow-y: auto;
    text-align: center;
    padding: 6px 0;
    scroll-behavior: smooth;
    mask-image: linear-gradient(180deg, transparent, #000 18%, #000 82%, transparent);
    -webkit-mask-image: linear-gradient(180deg, transparent, #000 18%, #000 82%, transparent);
  }
  .np-lyric-line {
    font-size: 14px; line-height: 2.2;
    color: rgba(255,255,255,0.4);
    transition: color 0.3s ease, transform 0.3s ease, font-size 0.3s ease;
  }
  .np-lyric-line.on {
    color: #fff;
    font-size: 16px;
    font-weight: 700;
    transform: scale(1.02);
  }

  .np-progress { display: flex; align-items: center; gap: 12px; margin-top: 28px; }
  .np-time {
    flex: none; width: 40px;
    font-size: 11.5px; color: rgba(255,255,255,0.55);
    font-variant-numeric: tabular-nums;
  }
  .np-time:last-child { text-align: right; }
  .np-track {
    flex: 1; height: 5px;
    background: rgba(255,255,255,0.16);
    border-radius: 999px; cursor: pointer;
  }
  .np-track:hover { height: 7px; }
  .np-track-fill {
    height: 100%;
    background: linear-gradient(90deg, #4fa3ff, #67e8f9);
    border-radius: 999px;
  }

  .np-ctrl {
    display: flex; align-items: center; justify-content: center;
    gap: 18px; margin-top: 24px;
  }
  .np-ctrl-btn {
    font-family: inherit;
    width: 46px; height: 46px;
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 50%;
    background: rgba(255,255,255,0.08);
    color: #fff; font-size: 16px;
    cursor: pointer;
    transition: background 0.15s ease, transform 0.15s ease;
  }
  .np-ctrl-btn:hover { background: rgba(255,255,255,0.2); }
  .np-ctrl-btn:active { transform: scale(0.92); }
  .np-ctrl-btn.skip { font-size: 18px; }
  .np-ctrl-btn.main {
    width: 62px; height: 62px;
    font-size: 22px;
    background: linear-gradient(140deg, #4fa3ff, #0b7efc);
    border-color: transparent;
    box-shadow: 0 8px 24px rgba(11,126,252,0.5);
  }
  .np-ctrl-btn.on { background: rgba(103,232,249,0.25); border-color: rgba(103,232,249,0.5); }

  .np-queue { margin-top: 36px; }
  .np-queue-title {
    font-size: 13px; font-weight: 800; letter-spacing: 1px;
    color: rgba(255,255,255,0.75);
  }
  .np-queue-list { list-style: none; margin-top: 10px; }
  .np-queue-list li {
    display: flex; align-items: center; gap: 12px;
    padding: 9px 12px;
    border-radius: 10px;
    cursor: pointer;
    transition: background 0.15s ease;
  }
  .np-queue-list li:hover { background: rgba(255,255,255,0.08); }
  .np-queue-list li.on { background: rgba(11,126,252,0.25); }
  .np-queue-no {
    flex: none; width: 20px; text-align: center;
    font-size: 12px; color: rgba(255,255,255,0.45);
    font-variant-numeric: tabular-nums;
  }
  .np-queue-name { font-size: 13px; font-weight: 600; }
  .np-queue-artist { margin-left: auto; font-size: 12px; color: rgba(255,255,255,0.5); }

  .np-empty {
    position: relative; z-index: 1;
    text-align: center;
    padding: 120px 20px;
    color: rgba(255,255,255,0.7);
  }
  .np-empty button {
    font-family: inherit;
    margin-top: 16px;
    height: 40px; padding: 0 26px;
    border: 0; border-radius: 999px;
    background: linear-gradient(140deg, #4fa3ff, #0b7efc);
    color: #fff; font-size: 13.5px; font-weight: 700;
    cursor: pointer;
  }
</style>
