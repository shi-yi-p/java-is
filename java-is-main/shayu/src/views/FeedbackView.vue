<script setup>
import { ref, onMounted } from 'vue'

const API = ''
const toastMsg = ref('')
let toastTimer = null
function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2800)
}
function authHeaders() {
  let token = ''
  try { token = localStorage.getItem('shark_token') || '' } catch (e) {}
  return { Authorization: 'Bearer ' + token, 'Content-Type': 'application/json' }
}

/* ============ 反馈类型 ============ */
const TYPES = [
  { key: 'bug',        label: '问题反馈', emoji: '🐛', color: '#f06a6a', soft: '#ffe4e4' },
  { key: 'suggestion', label: '功能建议', emoji: '💡', color: '#f5a25b', soft: '#ffeedb' },
  { key: 'music',      label: '音乐内容', emoji: '🎵', color: '#4f8ff7', soft: '#e4efff' },
  { key: 'other',      label: '其他',     emoji: '📮', color: '#9b7bf0', soft: '#eee6ff' }
]
const selectedType = ref('bug')
function typeInfo(key) {
  return TYPES.find(t => t.key === key) || TYPES[0]
}

/* ============ 表单 ============ */
const content = ref('')
const contact = ref('')
const submitting = ref(false)
const MAX = 2000

async function submitFeedback() {
  const text = content.value.trim()
  if (!text) return toast('请先写下你的想法 🐟')
  if (text.length > MAX) return toast('内容太长了，请控制在 2000 字内')
  if (submitting.value) return
  submitting.value = true
  try {
    const res = await fetch(API + '/api/feedback', {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify({ type: selectedType.value, content: text, contact: contact.value.trim() })
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok && d.code === 200) {
      toast('提交成功，感谢你的反馈！🎉')
      content.value = ''
      contact.value = ''
      await loadMine()
    } else {
      toast(d.message || '提交失败，请稍后再试')
    }
  } catch (e) {
    toast('无法连接服务器 🔌')
  } finally {
    submitting.value = false
  }
}

/* ============ 我的反馈记录 ============ */
const records = ref([])
const loading = ref(true)
async function loadMine() {
  loading.value = true
  try {
    const res = await fetch(API + '/api/feedback/mine', { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    records.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    records.value = []
  } finally {
    loading.value = false
  }
}
onMounted(loadMine)

function statusText(s) { return s === 1 ? '已处理' : '待处理' }
function shortTime(t) { return t ? String(t).slice(5, 16) : '' }

function goHome() { location.hash = '#/home' }
</script>

<template>
  <main class="fb-shell">
    <div class="fb-deco bubble a"></div>
    <div class="fb-deco bubble b"></div>
    <div class="fb-deco dot c"></div>

    <header class="fb-hero">
      <a class="fb-back" href="#" @click.prevent="goHome">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回首页
      </a>

      <div class="fb-hero-text">
        <em>SHARK FEEDBACK · 意见反馈</em>
        <h2>意见反馈</h2>
        <p>你的每条建议，都是鲨鱼音乐变好的动力～ 来聊聊吧！</p>
      </div>

      <!-- Q 版鲨鱼信使 -->
      <svg class="fb-mascot" viewBox="0 0 120 100" aria-hidden="true">
        <path d="M86 24 C94 12 106 10 112 15 C109 25 101 32 93 34 Z" fill="#8FBCF0" stroke="#3A3A3A" stroke-width="4.5" stroke-linejoin="round"/>
        <path d="M56 10 C28 10 16 32 16 54 C16 76 34 88 56 88 L94 88 C99 88 101 83 98 79 L89 64 C96 55 96 28 80 18 C72 12 64 10 56 10 Z"
              fill="#8FBCF0" stroke="#3A3A3A" stroke-width="4.5" stroke-linejoin="round"/>
        <path d="M52 38 C34 42 30 64 37 82 C44 88 55 89 65 88 C72 78 70 48 63 40 C59 37 55 37 52 38 Z" fill="#FFF9F0"/>
        <path d="M70 50 q4 -6 9 0" fill="none" stroke="#3A3A3A" stroke-width="4" stroke-linecap="round"/>
        <ellipse cx="65" cy="58" rx="5.5" ry="3.8" fill="#F7B3BE"/>
        <circle cx="76" cy="55" r="3" fill="#3A3A3A"/>
        <!-- 信封 -->
        <rect x="40" y="60" width="34" height="24" rx="4" fill="#FFF9F0" stroke="#3A3A3A" stroke-width="4"/>
        <path d="M40 64 L57 76 L74 64" fill="none" stroke="#F0808C" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M96 46 l3 -8 3 8 8 3 -8 3 -3 8 -3 -8 -8 -3 Z" fill="#F5C86A"/>
      </svg>
    </header>

    <div class="fb-body">
      <!-- 提交表单 -->
      <section class="fb-card fb-form-card">
        <div class="fb-card-head">
          <span class="fb-card-emoji">✍️</span>
          <div>
            <h3>写下你的反馈</h3>
            <p>问题、建议、想听的歌，都可以告诉我们</p>
          </div>
        </div>

        <div class="fb-field">
          <label>反馈类型</label>
          <div class="fb-types">
            <button
              v-for="t in TYPES"
              :key="t.key"
              type="button"
              class="fb-type"
              :class="{ active: selectedType === t.key }"
              :style="selectedType === t.key ? { background: t.soft, borderColor: t.color, color: t.color } : {}"
              @click="selectedType = t.key"
            >
              <span>{{ t.emoji }}</span>{{ t.label }}
            </button>
          </div>
        </div>

        <div class="fb-field">
          <label>反馈内容 <span class="fb-required">*</span></label>
          <textarea
            v-model="content"
            class="fb-textarea"
            :maxlength="MAX"
            rows="6"
            placeholder="请详细描述你遇到的问题或想提的建议…"
          ></textarea>
          <div class="fb-counter">{{ content.length }} / {{ MAX }}</div>
        </div>

        <div class="fb-field">
          <label>联系方式 <span class="fb-optional">选填</span></label>
          <input
            v-model="contact"
            type="text"
            class="fb-input"
            maxlength="128"
            placeholder="邮箱 / QQ / 手机号，方便我们回复你"
          />
        </div>

        <button class="fb-submit" type="button" :disabled="submitting" @click="submitFeedback">
          {{ submitting ? '提交中…' : '提交反馈 📮' }}
        </button>
      </section>

      <!-- 我的反馈记录 -->
      <section class="fb-card fb-list-card">
        <div class="fb-card-head">
          <span class="fb-card-emoji">📬</span>
          <div>
            <h3>我的反馈</h3>
            <p>共 {{ records.length }} 条 · 处理进度在这里查看</p>
          </div>
        </div>

        <div v-if="loading" class="fb-loading">加载中…</div>

        <div v-else-if="records.length === 0" class="fb-empty">
          <div class="fb-empty-icon">🐟</div>
          <p>还没有提交过反馈</p>
          <span>在左侧写下第一条建议吧～</span>
        </div>

        <div v-else class="fb-records">
          <article v-for="r in records" :key="r.id" class="fb-record">
            <div class="fb-record-top">
              <span class="fb-tag" :style="{ background: typeInfo(r.type).soft, color: typeInfo(r.type).color }">
                {{ typeInfo(r.type).emoji }} {{ typeInfo(r.type).label }}
              </span>
              <span class="fb-status" :class="{ done: r.status === 1 }">{{ statusText(r.status) }}</span>
              <time class="fb-time">{{ shortTime(r.createTime) }}</time>
            </div>
            <p class="fb-record-content">{{ r.content }}</p>
            <div v-if="r.contact" class="fb-record-contact">联系方式：{{ r.contact }}</div>
            <div v-if="r.reply" class="fb-reply">
              <b>官方回复：</b>{{ r.reply }}
            </div>
          </article>
        </div>
      </section>
    </div>

    <div class="fb-foot">
      <a href="#" class="fb-foot-link" @click.prevent="goHome">🏠 回到首页</a>
    </div>

    <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
  </main>
</template>

<style scoped>
.fb-shell {
  min-height: 100vh;
  background: radial-gradient(1100px 600px at 12% 6%, #ffffff 0%, #eef4fe 55%, #e4eefc 100%);
  padding-bottom: 40px;
  overflow: hidden;
  position: relative;
}
.fb-deco { position: absolute; border-radius: 50%; pointer-events: none; z-index: 0; }
.fb-deco.bubble { background: radial-gradient(circle at 32% 30%, #ffffff 0%, #a9c8f0 65%, #7fa9e2 100%); opacity: .45; }
.fb-deco.bubble.a { width: 120px; height: 120px; left: -30px; top: 220px; }
.fb-deco.bubble.b { width: 80px; height: 80px; right: 40px; top: 460px; opacity: .3; }
.fb-deco.dot { width: 18px; height: 18px; background: #ffd6dd; }
.fb-deco.dot.c { right: 16%; top: 120px; }

.fb-hero {
  position: relative;
  background: linear-gradient(135deg, #a9c8f0 0%, #7fa9e2 60%, #6f9ce0 100%);
  padding: 26px 5vw 64px;
  min-height: 210px;
  border-radius: 0 0 42px 42px;
  box-shadow: 0 18px 40px -18px rgba(80, 116, 175, .5);
}
.fb-back {
  display: inline-flex; align-items: center; gap: 6px;
  color: #fff; text-decoration: none; font-size: 14px; font-weight: 700;
  background: rgba(255,255,255,.2); padding: 7px 14px; border-radius: 999px;
  transition: background .2s;
}
.fb-back:hover { background: rgba(255,255,255,.34); }
.fb-back svg { width: 16px; height: 16px; }
.fb-hero-text { margin-top: 18px; color: #fff; }
.fb-hero-text em { font-style: normal; font-size: 12px; letter-spacing: 2px; opacity: .85; }
.fb-hero-text h2 { font-size: 34px; margin: 6px 0; text-shadow: 0 3px 10px rgba(0,0,0,.12); }
.fb-hero-text p { font-size: 14px; opacity: .95; }
.fb-mascot { position: absolute; right: 8vw; bottom: 6px; width: 150px; height: 125px; }

.fb-body {
  position: relative;
  z-index: 1;
  max-width: 1080px;
  margin: -34px auto 0;
  padding: 0 20px;
  display: grid;
  grid-template-columns: 1.1fr 1fr;
  gap: 22px;
  align-items: start;
}
.fb-card {
  background: #fff;
  border-radius: var(--radius-lg, 28px);
  padding: 26px 26px 30px;
  box-shadow: var(--shadow-card, 0 30px 70px -30px rgba(70, 104, 160, .55));
}
.fb-card-head { display: flex; align-items: center; gap: 12px; margin-bottom: 22px; }
.fb-card-emoji {
  width: 46px; height: 46px; flex: none;
  display: grid; place-items: center;
  font-size: 24px; background: var(--cream, #fdf6ec);
  border-radius: 16px;
}
.fb-card-head h3 { font-size: 19px; color: var(--ink, #2f3238); }
.fb-card-head p { font-size: 12.5px; color: var(--ink-soft, #6b7078); margin-top: 3px; }

.fb-field { margin-bottom: 18px; }
.fb-field label {
  display: block; font-size: 13.5px; font-weight: 700;
  color: var(--ink, #2f3238); margin-bottom: 9px;
}
.fb-required { color: #f06a6a; }
.fb-optional { font-weight: 400; color: var(--ink-soft, #6b7078); font-size: 12px; margin-left: 4px; }
.fb-types { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; }
.fb-type {
  display: flex; flex-direction: column; align-items: center; gap: 3px;
  padding: 11px 4px; border: 2px solid #e6edf8; border-radius: 14px;
  background: #fafcff; color: var(--ink-soft, #6b7078);
  font-size: 12px; font-weight: 700; cursor: pointer;
  transition: transform .15s, border-color .15s;
}
.fb-type:hover { transform: translateY(-2px); }
.fb-type span { font-size: 20px; }
.fb-textarea, .fb-input {
  width: 100%; border: 2px solid #e6edf8; border-radius: 14px;
  padding: 12px 14px; font-size: 14px; font-family: inherit;
  color: var(--ink, #2f3238); background: #fafcff;
  outline: none; transition: border-color .2s;
  resize: vertical;
}
.fb-textarea:focus, .fb-input:focus { border-color: var(--shark-blue-deep, #7fa9e2); }
.fb-counter { text-align: right; font-size: 12px; color: var(--ink-soft, #6b7078); margin-top: 5px; }
.fb-submit {
  width: 100%; border: none; border-radius: 16px; padding: 14px;
  font-size: 15px; font-weight: 800; color: #fff; cursor: pointer;
  background: linear-gradient(135deg, #7fa9e2, #6f9ce0);
  box-shadow: 0 12px 24px -10px rgba(80, 116, 175, .7);
  transition: transform .15s, opacity .2s;
}
.fb-submit:hover { transform: translateY(-2px); }
.fb-submit:disabled { opacity: .6; cursor: not-allowed; transform: none; }

.fb-loading { text-align: center; color: var(--ink-soft, #6b7078); padding: 40px 0; font-size: 14px; }
.fb-empty { text-align: center; padding: 40px 10px; color: var(--ink-soft, #6b7078); }
.fb-empty-icon { font-size: 46px; margin-bottom: 8px; }
.fb-empty p { font-weight: 700; color: var(--ink, #2f3238); margin-bottom: 4px; }
.fb-empty span { font-size: 12.5px; }
.fb-records { display: flex; flex-direction: column; gap: 12px; max-height: 520px; overflow-y: auto; padding-right: 4px; }
.fb-record {
  border: 2px solid #eef3fb; border-radius: 16px; padding: 14px 16px;
  background: #fcfdff;
}
.fb-record-top { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.fb-tag { font-size: 11.5px; font-weight: 700; padding: 3px 10px; border-radius: 999px; }
.fb-status {
  font-size: 11.5px; font-weight: 700; padding: 3px 10px; border-radius: 999px;
  background: #fff3d6; color: #c98a1e;
}
.fb-status.done { background: #e1f6ea; color: #2e9e62; }
.fb-time { font-size: 11.5px; color: var(--ink-soft, #6b7078); margin-left: auto; }
.fb-record-content { font-size: 14px; color: var(--ink, #2f3238); line-height: 1.6; margin: 10px 0 6px; white-space: pre-wrap; word-break: break-word; }
.fb-record-contact { font-size: 12px; color: var(--ink-soft, #6b7078); }
.fb-reply {
  margin-top: 10px; padding: 10px 12px; border-radius: 12px;
  background: #eef4fe; font-size: 13px; color: var(--ink, #2f3238); line-height: 1.6;
}
.fb-reply b { color: var(--shark-blue-deep, #7fa9e2); }

.fb-foot { text-align: center; margin: 34px 0 0; }
.fb-foot-link { color: var(--ink-soft, #6b7078); text-decoration: none; font-size: 13px; font-weight: 700; }
.fb-foot-link:hover { color: var(--shark-blue-deep, #7fa9e2); }

.toast {
  position: fixed; left: 50%; bottom: 34px; transform: translate(-50%, 130%);
  background: var(--ink, #2f3238); color: #fff; font-weight: 700; font-size: 13.5px;
  padding: 13px 22px; border-radius: 999px; z-index: 20;
  transition: transform .35s cubic-bezier(.2,.9,.3,1.4);
  box-shadow: 0 12px 30px -10px rgba(0,0,0,.5);
}
.toast.show { transform: translate(-50%, 0); }

@media (max-width: 860px) {
  .fb-body { grid-template-columns: 1fr; }
  .fb-mascot { width: 110px; height: 92px; right: 4vw; }
}
@media (max-width: 420px) {
  .fb-types { grid-template-columns: repeat(2, 1fr); }
}
</style>
