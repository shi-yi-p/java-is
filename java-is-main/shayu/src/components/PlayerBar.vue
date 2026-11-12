<script setup>
/* ============================================================
 * 底部播放条（酷狗式）：显示当前歌曲 / 播放控制 / 进度条
 * ============================================================ */
import { player, togglePlay, next, prev, seek, fmtTime, cycleMode, isFavorite, toggleFavorite } from '../player.js'
import { ref, computed, onMounted, onUnmounted } from 'vue'

const barEl = ref(null)
const dragging = ref(false)

const percent = computed(() =>
  player.duration ? Math.min(100, (player.cur / player.duration) * 100) : 0
)

/* 播放模式文案与图标 */
const modeLabel = computed(() => {
  if (player.mode === 'one') return '🔂'
  if (player.mode === 'order') return '🔁'   /* 顺序播放：播完即停 */
  return '🔁'                                 /* list 列表循环 */
})
const modeText = computed(() => {
  if (player.mode === 'one') return '单曲循环'
  if (player.mode === 'order') return '顺序播放'
  return '列表循环'
})

/* 当前歌曲是否已收藏 */
const fav = computed(() => isFavorite(player.song))

function toggleMode() {
  cycleMode()
  try { window.dispatchEvent(new CustomEvent('shark-toast', { detail: '播放模式：' + modeText.value })) } catch (e) {}
}

async function onFav() {
  const msg = await toggleFavorite(player.song)
  try { window.dispatchEvent(new CustomEvent('shark-toast', { detail: msg })) } catch (e) {}
}

/* 根据进度条位置计算秒数 */
function ratioToSec(e, el) {
  const rect = el.getBoundingClientRect()
  const ratio = Math.min(1, Math.max(0, (e.clientX - rect.left) / rect.width))
  return ratio * (player.duration || 0)
}

/* 点击进度条跳转 */
function onSeek(e) {
  seek(ratioToSec(e, e.currentTarget))
}

/* 拖拽进度条：按下后跟踪鼠标移动 */
function onDown(e) {
  const track = e.currentTarget
  dragging.value = true
  const move = (ev) => seek(ratioToSec(ev, track))
  const up = () => {
    dragging.value = false
    window.removeEventListener('mousemove', move)
    window.removeEventListener('mouseup', up)
  }
  window.addEventListener('mousemove', move)
  window.addEventListener('mouseup', up)
  seek(ratioToSec(e, track))
}

function closeBar() {
  player.open = false
  try { window.dispatchEvent(new CustomEvent('shark-toast', { detail: '已收起播放器 🎧' })) } catch (e) {}
}
</script>

<template>
  <div v-if="player.song" class="pb-bar">
    <!-- 歌曲信息 -->
    <div class="pb-info">
      <span class="pb-disc" :class="{ spin: player.playing }">💿</span>
      <div class="pb-meta">
        <b class="pb-title">{{ player.song.title }}</b>
        <span class="pb-artist">{{ player.song.artist }} · {{ player.song.album }}</span>
      </div>
    </div>

    <!-- 控制区 -->
    <div class="pb-ctrl">
      <button class="pb-btn" type="button" title="上一首" @click="prev">⏮</button>
      <button class="pb-btn main" type="button" :title="player.playing ? '暂停' : '播放'" @click="togglePlay">
        {{ player.playing ? '⏸' : '▶' }}
      </button>
      <button class="pb-btn" type="button" title="下一首" @click="next">⏭</button>
      <button class="pb-btn" type="button" :title="modeText" @click="toggleMode">{{ modeLabel }}</button>
    </div>

    <!-- 进度区 -->
    <div class="pb-progress">
      <span class="pb-time">{{ fmtTime(player.cur) }}</span>
      <div class="pb-track" :class="{ dragging }" @click="onSeek" @mousedown="onDown">
        <div class="pb-track-fill" :style="{ width: percent + '%' }">
          <span class="pb-thumb"></span>
        </div>
      </div>
      <span class="pb-time">{{ fmtTime(player.duration) }}</span>
    </div>

    <!-- 收藏 / 展开 / 收起 -->
    <div class="pb-extra">
      <button class="pb-btn small" type="button" :title="fav ? '取消收藏' : '收藏'" :class="{ on: fav }" @click="onFav">{{ fav ? '❤️' : '🤍' }}</button>
      <button class="pb-btn small" type="button" title="展开正在播放" @click="player.open = true" v-if="!player.open">⤢</button>
      <button class="pb-btn small" type="button" title="收起" @click="closeBar" v-else>✕</button>
    </div>
  </div>
</template>

<style>
  .pb-bar {
    position: fixed;
    left: 0; right: 0; bottom: 0;
    z-index: 70;
    display: flex;
    align-items: center;
    gap: 26px;
    height: 68px;
    padding: 0 max(30px, calc((100vw - 1200px) / 2));
    background: rgba(16, 22, 33, 0.96);
    backdrop-filter: blur(10px);
    color: #fff;
    box-shadow: 0 -8px 24px rgba(15, 23, 42, 0.25);
  }
  .pb-info { display: flex; align-items: center; gap: 12px; flex: none; min-width: 0; max-width: 30%; }
  .pb-disc { font-size: 30px; line-height: 1; }
  .pb-disc.spin { animation: pbSpin 3.2s linear infinite; }
  @keyframes pbSpin { to { transform: rotate(360deg); } }
  .pb-meta { display: flex; flex-direction: column; gap: 2px; min-width: 0; }
  .pb-title {
    font-size: 13.5px; font-weight: 700;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .pb-artist {
    font-size: 11.5px; color: rgba(255, 255, 255, 0.6);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }

  .pb-ctrl { display: flex; align-items: center; gap: 10px; flex: none; }
  .pb-btn {
    font-family: inherit;
    width: 34px; height: 34px;
    border: 0; border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
    color: #fff; font-size: 14px;
    cursor: pointer;
    display: grid; place-items: center;
    transition: background 0.15s ease, transform 0.15s ease;
  }
  .pb-btn:hover { background: rgba(255, 255, 255, 0.22); }
  .pb-btn:active { transform: scale(0.92); }
  .pb-btn.main {
    width: 42px; height: 42px;
    background: linear-gradient(140deg, #4fa3ff, #0b7efc);
    font-size: 16px;
    box-shadow: 0 4px 12px rgba(11, 126, 252, 0.45);
  }
  .pb-btn.main:hover { filter: brightness(1.08); }
  .pb-btn.small { width: 28px; height: 28px; font-size: 12px; }

  .pb-progress { flex: 1; display: flex; align-items: center; gap: 10px; min-width: 0; }
  .pb-time {
    flex: none;
    font-size: 11px; color: rgba(255, 255, 255, 0.55);
    font-variant-numeric: tabular-nums;
    width: 36px;
  }
  .pb-time:last-child { text-align: right; }
  .pb-track {
    flex: 1; height: 5px;
    background: rgba(255, 255, 255, 0.16);
    border-radius: 999px;
    cursor: pointer;
    position: relative;
    transition: height 0.15s ease;
  }
  .pb-track:hover, .pb-track.dragging { height: 7px; }
  .pb-track-fill {
    height: 100%;
    background: linear-gradient(90deg, #4fa3ff, #0b7efc);
    border-radius: 999px;
    position: relative;
    transition: width 0.15s linear;
  }
  .pb-thumb {
    position: absolute; right: -5px; top: 50%;
    transform: translateY(-50%) scale(0);
    width: 12px; height: 12px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 1px 4px rgba(0,0,0,0.4);
    transition: transform 0.15s ease;
  }
  .pb-track:hover .pb-thumb, .pb-track.dragging .pb-thumb { transform: translateY(-50%) scale(1); }

  .pb-extra { flex: none; display: flex; gap: 6px; }
  .pb-extra .pb-btn.on { background: rgba(255, 154, 160, 0.25); }

  @media (max-width: 940px) {
    .pb-bar { gap: 12px; padding: 0 14px; }
    .pb-progress { display: none; }
    .pb-info { max-width: 50%; }
  }
</style>
