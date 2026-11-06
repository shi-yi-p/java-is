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
  return { Authorization: 'Bearer ' + token, 'Content-Type': 'application/json' }
}

/* ============ 板块定义（每个板块独立风格配色） ============ */
const CATEGORIES = [
  { key: '',         label: '全部',   emoji: '🦈', color: '#8fbcF0', soft: '#e4f0fd' },
  { key: 'music',    label: '音乐分享', emoji: '🎵', color: '#4f8ff7', soft: '#e4efff' },
  { key: 'chat',     label: '闲聊灌水', emoji: '💬', color: '#f79bb0', soft: '#ffe6ec' },
  { key: 'song',     label: '歌单推荐', emoji: '📀', color: '#9b7bf0', soft: '#eee6ff' },
  { key: 'sing',     label: '唱歌达人', emoji: '🎤', color: '#f5a25b', soft: '#ffeedb' },
  { key: 'story',    label: '听歌故事', emoji: '📝', color: '#5bc08a', soft: '#e1f6ea' },
  { key: 'help',     label: '求助问答', emoji: '🆘', color: '#f06a6a', soft: '#ffe4e4' }
]

const activeCategory = ref('')   // 当前选中板块（'' = 全部）

function catInfo(key) {
  return CATEGORIES.find(c => c.key === key) || CATEGORIES[0]
}

/* ============ 帖子列表 ============ */
const posts = ref([])
const loading = ref(false)

async function loadPosts() {
  loading.value = true
  try {
    const q = activeCategory.value ? '?category=' + encodeURIComponent(activeCategory.value) : ''
    const res = await fetch(API + '/api/social/posts' + q, { headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    posts.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    posts.value = []
  } finally {
    loading.value = false
  }
}
onMounted(loadPosts)

function switchCategory(key) {
  activeCategory.value = key
  loadPosts()
}

/* ============ 发帖 ============ */
const showEditor = ref(false)
const newTitle = ref('')
const newContent = ref('')
const newCategory = ref('chat')   // 发帖默认板块

async function submitPost() {
  const title = newTitle.value.trim()
  const content = newContent.value.trim()
  if (!title) return toast('标题不能为空 🐟')
  if (!content) return toast('内容不能为空 🐟')
  try {
    const res = await fetch(API + '/api/social/post', {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify({ title, content, category: newCategory.value })
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) {
      toast('发帖成功 🎉')
      newTitle.value = ''
      newContent.value = ''
      showEditor.value = false
      // 跳到刚发布的板块，方便看到自己的帖子
      activeCategory.value = newCategory.value
      loadPosts()
    } else {
      toast(d.message || '发帖失败')
    }
  } catch (e) {
    toast('无法连接服务器 🔌')
  }
}

/* ============ 帖子详情 + 评论 ============ */
const detailPost = ref(null)
const comments = ref([])
const showDetail = ref(false)
const newComment = ref('')

async function openDetail(p) {
  detailPost.value = p
  showDetail.value = true
  newComment.value = ''
  // 拉取详情（浏览+1）和评论
  try {
    const [dRes, cRes] = await Promise.all([
      fetch(API + '/api/social/post?postId=' + p.id, { headers: authHeaders() }),
      fetch(API + '/api/social/comments?postId=' + p.id, { headers: authHeaders() })
    ])
    const d = await dRes.json().catch(() => ({}))
    const c = await cRes.json().catch(() => ({}))
    if (dRes.ok && d.data) detailPost.value = d.data
    comments.value = (cRes.ok && Array.isArray(c.data)) ? c.data : []
  } catch (e) { /* 静默 */ }
}

async function submitComment() {
  const content = newComment.value.trim()
  if (!content) return toast('评论内容不能为空 🐟')
  if (!detailPost.value) return
  try {
    const res = await fetch(API + '/api/social/comment', {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify({ postId: detailPost.value.id, content })
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) {
      toast('评论成功 💬')
      newComment.value = ''
      openDetail(detailPost.value)
    } else {
      toast(d.message || '评论失败')
    }
  } catch (e) {
    toast('无法连接服务器 🔌')
  }
}

async function likePost(p) {
  try {
    const res = await fetch(API + '/api/social/post/like?postId=' + p.id, { method: 'POST', headers: authHeaders() })
    const d = await res.json().catch(() => ({}))
    if (res.ok) {
      toast('点赞成功 ❤️')
      loadPosts()
    } else {
      toast(d.message || '点赞失败')
    }
  } catch (e) { toast('操作失败') }
}

/* 时间截断显示 */
function shortTime(t) {
  if (!t) return ''
  return t.slice(5, 16) // "MM-DD HH:mm"
}

/* 内容截断 */
function excerpt(c) {
  const t = String(c || '')
  return t.length > 80 ? t.slice(0, 80) + '…' : t
}

function goHome() { location.hash = '#/home' }
</script>

<template>
  <main class="fm-shell">
    <!-- 背景漂浮装饰 -->
    <div class="fm-deco flower a"></div>
    <div class="fm-deco flower b"></div>
    <div class="fm-deco dot c"></div>
    <div class="fm-deco dot d"></div>

    <header class="fm-hero">
      <a class="fm-back" href="#" @click.prevent="goHome">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
        返回首页
      </a>

      <div class="fm-hero-text">
        <em>SHARK FORUM · 鲨鲨小岛</em>
        <h2>鲨鱼论坛</h2>
        <p>和鲨鲨们一起聊音乐、聊生活，分享你的听歌故事～</p>
      </div>

      <!-- Q弹鲨鱼吉祥物（抱着奶茶） -->
      <svg class="fm-mascot" viewBox="0 0 100 96" aria-hidden="true">
        <!-- 背鳍 -->
        <path d="M74 20 C80 10 90 8 94 12 C92 20 86 26 80 28 Z" fill="#8FBCF0" stroke="#3A3A3A" stroke-width="4.5" stroke-linejoin="round"/>
        <!-- 身体 -->
        <path d="M50 8 C24 8 12 28 12 50 C12 72 28 84 50 84 L86 84 C90 84 92 80 90 76 L82 62 C88 54 88 30 74 18 C66 12 58 8 50 8 Z"
              fill="#8FBCF0" stroke="#3A3A3A" stroke-width="4.5" stroke-linejoin="round"/>
        <!-- 肚皮 -->
        <path d="M46 34 C30 38 26 58 32 76 C38 82 48 84 58 83 C64 74 62 46 56 36 C53 33 49 33 46 34 Z" fill="#FFF9F0"/>
        <!-- 手手抱着奶茶 -->
        <rect x="34" y="56" width="22" height="24" rx="4" fill="#FFF9F0" stroke="#3A3A3A" stroke-width="4"/>
        <path d="M40 50 q4 -8 8 0" fill="none" stroke="#3A3A3A" stroke-width="3.5" stroke-linecap="round"/>
        <circle cx="42" cy="74" r="2.6" fill="#3A3A3A"/>
        <circle cx="49" cy="76" r="2.6" fill="#3A3A3A"/>
        <circle cx="46" cy="70" r="2.6" fill="#3A3A3A"/>
        <!-- 眼睛 -->
        <path d="M62 46 q4 -6 9 0" fill="none" stroke="#3A3A3A" stroke-width="4" stroke-linecap="round"/>
        <!-- 腮红 -->
        <ellipse cx="58" cy="54" rx="5.5" ry="3.8" fill="#F7B3BE"/>
        <ellipse cx="80" cy="50" rx="5" ry="3.5" fill="#F7B3BE"/>
        <!-- 开心大嘴 -->
        <path d="M64 58 q9 11 20 2 q-2 9 -11 9 q-8 0 -9 -11 Z" fill="#F0808C" stroke="#3A3A3A" stroke-width="3.5" stroke-linejoin="round"/>
      </svg>

      <div class="fm-hero-actions">
        <button class="fm-hero-post" type="button" @click="showEditor = !showEditor">✎ 发帖</button>
      </div>
    </header>

    <div class="fm-body">
      <!-- 板块 Tab 栏 -->
      <nav class="fm-cats">
        <button
          v-for="c in CATEGORIES"
          :key="c.key"
          class="fm-cat"
          :class="{ on: activeCategory === c.key }"
          type="button"
          :style="activeCategory === c.key ? { background: c.color, borderColor: 'var(--fm-ink)' } : {}"
          @click="switchCategory(c.key)"
        >
          <span class="fm-cat-emoji">{{ c.emoji }}</span>
          <span class="fm-cat-label">{{ c.label }}</span>
        </button>
      </nav>

      <!-- 发帖编辑器 -->
      <div v-if="showEditor" class="fm-editor">
        <h3>✏️ 发布新帖</h3>
        <div class="fm-editor-cats">
          <span class="fm-editor-cats-label">选择板块：</span>
          <button
            v-for="c in CATEGORIES.filter(x => x.key)"
            :key="c.key"
            class="fm-cat-pick"
            :class="{ on: newCategory === c.key }"
            type="button"
            :style="newCategory === c.key ? { background: c.color, color: '#fff' } : {}"
            @click="newCategory = c.key"
          >{{ c.emoji }} {{ c.label }}</button>
        </div>
        <input v-model="newTitle" class="fm-editor-title" type="text" placeholder="标题（一句话说清主题）" maxlength="128" />
        <textarea v-model="newContent" class="fm-editor-content" placeholder="正文内容，鲨鲨们等着看呢…" rows="5"></textarea>
        <div class="fm-editor-foot">
          <button class="fm-cancel" type="button" @click="showEditor = false">取消</button>
          <button class="fm-submit" type="button" @click="submitPost">发布帖子</button>
        </div>
      </div>

      <!-- 帖子列表 -->
      <div v-if="loading" class="fm-loading">鲨鲨正在翻帖子…</div>
      <template v-else>
        <div v-if="posts.length" class="fm-posts">
          <article v-for="p in posts" :key="p.id" class="fm-post" @click="openDetail(p)">
            <div class="fm-post-head">
              <span class="fm-post-ava">{{ p.avatarLetter }}</span>
              <div class="fm-post-meta">
                <b>{{ p.nickname }}</b>
                <span>{{ shortTime(p.createTime) }}</span>
              </div>
              <span class="fm-post-tag" :style="{ background: catInfo(p.category).soft, color: catInfo(p.category).color }">
                {{ catInfo(p.category).emoji }} {{ catInfo(p.category).label }}
              </span>
            </div>
            <h4 class="fm-post-title">{{ p.title }}</h4>
            <p class="fm-post-content">{{ excerpt(p.content) }}</p>
            <div class="fm-post-foot">
              <span class="fm-stat">❤ {{ p.likes }}</span>
              <span class="fm-stat">💬 {{ p.comments }}</span>
              <span class="fm-stat">👀 {{ p.views }}</span>
            </div>
          </article>
        </div>
        <div v-else class="fm-empty">
          <svg viewBox="0 0 100 92" class="fm-empty-shark" aria-hidden="true">
            <path d="M50 8 C24 8 12 28 12 50 C12 72 28 84 50 84 L88 84 C92 84 94 80 92 76 L84 60 C90 52 90 30 74 18 C66 12 58 8 50 8 Z"
                  fill="#B8D4F8" stroke="#3A3A3A" stroke-width="4.5" stroke-linejoin="round"/>
            <path d="M34 46 q4 -6 9 0" fill="none" stroke="#3A3A3A" stroke-width="4" stroke-linecap="round"/>
            <path d="M60 46 q4 -6 9 0" fill="none" stroke="#3A3A3A" stroke-width="4" stroke-linecap="round"/>
            <ellipse cx="30" cy="56" rx="6" ry="4" fill="#F7B3BE"/>
            <ellipse cx="74" cy="54" rx="6" ry="4" fill="#F7B3BE"/>
            <circle cx="52" cy="60" r="5" fill="#3A3A3A"/>
          </svg>
          <p>这个板块还没有帖子，来发第一帖吧～</p>
          <button type="button" @click="showEditor = true">✎ 发第一帖</button>
        </div>
      </template>
    </div>

    <!-- 帖子详情弹窗 -->
    <div v-if="showDetail && detailPost" class="fm-modal-mask" @click.self="showDetail = false">
      <div class="fm-modal">
        <div class="fm-modal-head">
          <b>{{ detailPost.title }}</b>
          <i class="fm-modal-close" @click="showDetail = false">✕</i>
        </div>
        <div class="fm-modal-meta">
          <span class="fm-post-ava sm">{{ detailPost.avatarLetter }}</span>
          <b>{{ detailPost.nickname }}</b>
          <span>{{ detailPost.createTime }}</span>
          <button class="fm-like-btn" type="button" @click="likePost(detailPost)">❤ {{ detailPost.likes }}</button>
        </div>
        <p class="fm-modal-content">{{ detailPost.content }}</p>

        <!-- 评论 -->
        <div class="fm-comments">
          <h4>💬 评论 ({{ comments.length }})</h4>
          <div v-if="comments.length" class="fm-comment-list">
            <div v-for="c in comments" :key="c.id" class="fm-comment">
              <span class="fm-post-ava sm">{{ c.avatarLetter }}</span>
              <div class="fm-comment-body">
                <b>{{ c.nickname }}</b>
                <p>{{ c.content }}</p>
                <span class="fm-comment-time">{{ c.createTime }}</span>
              </div>
            </div>
          </div>
          <div v-else class="fm-no-comment">还没有评论，抢个沙发吧～</div>

          <div class="fm-comment-input">
            <input v-model="newComment" type="text" placeholder="写下你的评论…" @keyup.enter="submitComment" />
            <button type="button" @click="submitComment">发送</button>
          </div>
        </div>
      </div>
    </div>

    <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
  </main>
</template>

<style>
  /* ============================================================
   * 鲨鱼吉祥物风格：柔和天蓝 + 奶油白 + 粉色腮红 + 奶黄花朵点缀
   * 圆润粗描边、Q弹贴纸感
   * ============================================================ */
  :root {
    --fm-blue: #8FBCF0;
    --fm-blue-light: #B8D4F8;
    --fm-blue-pale: #E4F0FD;
    --fm-cream: #FFF9F0;
    --fm-ink: #3A3A3A;
    --fm-pink: #F7B3BE;
    --fm-pink-deep: #F0808C;
    --fm-orange: #F5C06A;
  }

  body:has(.fm-shell) {
    padding: 0; display: block;
    background: linear-gradient(180deg, var(--fm-blue-pale) 0%, var(--fm-cream) 100%);
  }
  .fm-shell { position: relative; min-height: 100vh; padding-bottom: 60px; overflow-x: hidden; }

  /* ===== 背景装饰：粉色小花 + 奶黄圆点（呼应吉祥物贴纸元素） ===== */
  .fm-deco { position: fixed; pointer-events: none; z-index: 0; animation: fmFloat 7s ease-in-out infinite; }
  .fm-deco.flower { width: 52px; height: 52px; opacity: .75; }
  .fm-deco.flower::before, .fm-deco.flower::after {
    content: ''; position: absolute; background: var(--fm-pink); border: 3px solid var(--fm-ink); border-radius: 50%;
  }
  .fm-deco.flower::before { width: 24px; height: 24px; left: 0; top: 14px; }
  .fm-deco.flower::after { width: 24px; height: 24px; right: 0; top: 14px; }
  .fm-deco.flower.a { left: 4%; top: 26%; }
  .fm-deco.flower.b { right: 5%; top: 58%; animation-delay: -3s; }
  .fm-deco.dot {
    width: 26px; height: 26px; border-radius: 50%;
    background: var(--fm-orange); border: 3px solid var(--fm-ink); opacity: .7;
  }
  .fm-deco.dot.c { left: 10%; top: 66%; animation-delay: -1.6s; }
  .fm-deco.dot.d { right: 12%; top: 16%; animation-delay: -4.4s; }
  @keyframes fmFloat {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50% { transform: translateY(-14px) rotate(8deg); }
  }

  /* ===== 顶部横幅 ===== */
  .fm-hero {
    position: relative; z-index: 1;
    min-height: 230px;
    background: var(--fm-blue);
    border-bottom: 4px solid var(--fm-ink);
    border-radius: 0 0 36px 36px;
    box-shadow: 0 10px 0 rgba(58, 58, 58, 0.08);
    color: var(--fm-ink); overflow: hidden;
    padding: 44px max(34px, calc((100vw - 1200px) / 2)) 30px;
    display: flex; align-items: center; gap: 26px;
  }
  /* 奶油色波浪肚皮纹理 */
  .fm-hero::after {
    content: ''; position: absolute; right: -60px; bottom: -80px;
    width: 340px; height: 340px; border-radius: 50%;
    background: rgba(255, 249, 240, 0.35);
  }
  .fm-back {
    position: absolute; top: 20px; left: max(30px, calc((100vw - 1200px) / 2));
    display: inline-flex; align-items: center; gap: 6px;
    color: var(--fm-ink); font-size: 13px; font-weight: 800; text-decoration: none; z-index: 2;
    background: var(--fm-cream);
    border: 3px solid var(--fm-ink); border-radius: 999px;
    padding: 6px 16px 6px 10px;
    box-shadow: 0 3px 0 var(--fm-ink);
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .fm-back:hover { transform: translateY(-2px); box-shadow: 0 5px 0 var(--fm-ink); }
  .fm-back svg { width: 16px; height: 16px; }
  .fm-hero-text { position: relative; z-index: 1; }
  .fm-hero-text em {
    font-style: normal; font-size: 11px; font-weight: 900; letter-spacing: 3px;
    color: #5c7aa8;
    background: var(--fm-cream);
    border: 2.5px solid var(--fm-ink); border-radius: 999px;
    padding: 4px 14px; display: inline-block;
  }
  .fm-hero-text h2 { font-size: 34px; font-weight: 900; letter-spacing: 3px; margin-top: 12px; }
  .fm-hero-text p { margin-top: 8px; font-size: 13.5px; color: #46597a; font-weight: 600; }
  .fm-mascot {
    position: relative; z-index: 1;
    width: 150px; height: 144px; flex: none;
    filter: drop-shadow(0 6px 0 rgba(58,58,58,0.15));
    animation: fmBob 3.2s ease-in-out infinite;
  }
  @keyframes fmBob { 0%,100% { transform: translateY(0) rotate(-2deg); } 50% { transform: translateY(-8px) rotate(2deg); } }
  .fm-hero-actions { position: relative; z-index: 1; margin-left: auto; display: flex; gap: 12px; }
  .fm-hero-post, .fm-hero-chat {
    font-family: var(--font); font-size: 14px; font-weight: 800; color: var(--fm-ink);
    border: 3px solid var(--fm-ink); border-radius: 999px;
    padding: 10px 24px; cursor: pointer; text-decoration: none;
    box-shadow: 0 4px 0 var(--fm-ink);
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .fm-hero-post { background: var(--fm-pink); }
  .fm-hero-chat { background: var(--fm-orange); }
  .fm-hero-post:hover, .fm-hero-chat:hover { transform: translateY(-2px); box-shadow: 0 6px 0 var(--fm-ink); }
  .fm-hero-post:active, .fm-hero-chat:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--fm-ink); }

  .fm-body { position: relative; z-index: 1; max-width: 900px; margin: 0 auto; padding: 26px 34px; }

  /* ===== 板块 Tab 栏 ===== */
  .fm-cats {
    display: flex; flex-wrap: wrap; gap: 10px;
    margin-bottom: 22px;
  }
  .fm-cat {
    display: inline-flex; align-items: center; gap: 6px;
    font-family: var(--font); font-size: 13.5px; font-weight: 800; color: var(--fm-ink);
    background: #fff;
    border: 3px solid rgba(58,58,58,0.35); border-radius: 999px;
    padding: 8px 16px; cursor: pointer;
    box-shadow: 0 3px 0 rgba(58,58,58,0.25);
    transition: transform .15s ease, box-shadow .15s ease, background .15s ease, border-color .15s ease;
  }
  .fm-cat:hover { transform: translateY(-2px); }
  .fm-cat:active { transform: translateY(1px); box-shadow: 0 1px 0 rgba(58,58,58,0.25); }
  .fm-cat.on {
    border-color: var(--fm-ink);
    box-shadow: 0 4px 0 var(--fm-ink);
  }
  .fm-cat-emoji { font-size: 15px; line-height: 1; }
  .fm-cat-label { line-height: 1; }

  /* ===== 发帖编辑器 ===== */
  .fm-editor {
    background: #fff;
    border: 3px solid var(--fm-ink); border-radius: 20px;
    padding: 20px; margin-bottom: 22px;
    box-shadow: 0 6px 0 rgba(58,58,58,0.7);
  }
  .fm-editor h3 { font-size: 16px; font-weight: 900; color: var(--fm-ink); margin-bottom: 14px; }
  .fm-editor-cats { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; margin-bottom: 14px; }
  .fm-editor-cats-label { font-size: 13px; font-weight: 700; color: var(--fm-ink); }
  .fm-cat-pick {
    font-family: var(--font); font-size: 12.5px; font-weight: 700; color: var(--fm-ink);
    background: #fff;
    border: 2.5px solid rgba(58,58,58,0.35); border-radius: 999px;
    padding: 6px 14px; cursor: pointer;
    transition: transform .12s ease, box-shadow .12s ease, background .12s ease;
  }
  .fm-cat-pick:hover { transform: translateY(-1px); }
  .fm-cat-pick.on { border-color: var(--fm-ink); box-shadow: 0 2px 0 var(--fm-ink); }
  .fm-editor-title {
    width: 100%; height: 44px; padding: 0 16px;
    border: 3px solid var(--fm-ink); border-radius: 14px;
    font-family: var(--font); font-size: 14px; font-weight: 600; color: var(--fm-ink);
    margin-bottom: 12px; background: var(--fm-cream);
  }
  .fm-editor-title:focus, .fm-editor-content:focus {
    outline: none; background: #fff;
    box-shadow: 0 0 0 4px rgba(143,188,240,0.45);
  }
  .fm-editor-content {
    width: 100%; padding: 12px 16px;
    border: 3px solid var(--fm-ink); border-radius: 14px;
    font-family: var(--font); font-size: 14px; font-weight: 600; color: var(--fm-ink);
    resize: vertical; line-height: 1.7; background: var(--fm-cream);
  }
  .fm-editor-foot { display: flex; justify-content: flex-end; gap: 12px; margin-top: 14px; }
  .fm-cancel, .fm-submit {
    font-family: var(--font); font-size: 13.5px; font-weight: 800;
    border: 3px solid var(--fm-ink); border-radius: 999px; padding: 9px 22px; cursor: pointer;
    box-shadow: 0 3px 0 var(--fm-ink);
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .fm-cancel { color: var(--fm-ink); background: #fff; }
  .fm-submit { color: var(--fm-ink); background: var(--fm-pink); }
  .fm-cancel:hover, .fm-submit:hover { transform: translateY(-2px); box-shadow: 0 5px 0 var(--fm-ink); }
  .fm-cancel:active, .fm-submit:active { transform: translateY(1px); box-shadow: 0 1px 0 var(--fm-ink); }

  /* ===== 帖子列表（贴纸卡片） ===== */
  .fm-loading { text-align: center; padding: 60px; color: #7d8aa0; font-weight: 700; }
  .fm-posts { display: flex; flex-direction: column; gap: 18px; }
  .fm-post {
    background: #fff;
    border: 3px solid var(--fm-ink); border-radius: 20px;
    padding: 18px 20px; cursor: pointer;
    box-shadow: 0 5px 0 rgba(58,58,58,0.7);
    transition: transform .18s ease, box-shadow .18s ease;
  }
  .fm-post:hover { transform: translateY(-4px) rotate(-0.4deg); box-shadow: 0 9px 0 rgba(58,58,58,0.7); }
  .fm-post-head { display: flex; align-items: center; gap: 12px; }
  .fm-post-ava {
    flex: none; width: 44px; height: 44px; border-radius: 50%;
    background: var(--fm-blue-light);
    border: 3px solid var(--fm-ink);
    display: grid; place-items: center;
    font-size: 16px; font-weight: 900; color: var(--fm-ink);
  }
  .fm-post-ava.sm { width: 34px; height: 34px; font-size: 13px; }
  .fm-post-meta { display: flex; flex-direction: column; }
  .fm-post-meta b { font-size: 14px; font-weight: 800; color: var(--fm-ink); }
  .fm-post-meta span { font-size: 12px; color: #9aa5b5; font-weight: 600; }
  .fm-post-tag {
    margin-left: auto;
    font-size: 12px; font-weight: 800;
    border: 2.5px solid var(--fm-ink);
    border-radius: 999px;
    padding: 4px 12px;
    white-space: nowrap;
  }
  .fm-post-title { font-size: 17px; font-weight: 900; color: var(--fm-ink); margin-top: 14px; }
  .fm-post-content { font-size: 13.5px; color: #6b7280; line-height: 1.7; margin-top: 6px; font-weight: 500; }
  .fm-post-foot { display: flex; gap: 16px; margin-top: 14px; }
  .fm-stat {
    font-size: 12px; color: var(--fm-ink); font-weight: 700;
    background: var(--fm-blue-pale);
    border: 2px solid var(--fm-ink); border-radius: 999px;
    padding: 3px 12px;
  }

  .fm-empty { text-align: center; padding: 60px 20px; color: #7d8aa0; }
  .fm-empty-shark { width: 110px; height: 100px; animation: fmBob 3.2s ease-in-out infinite; }
  .fm-empty p { font-size: 14px; font-weight: 700; margin-top: 12px; }
  .fm-empty button {
    font-family: var(--font); margin-top: 18px; height: 44px; padding: 0 28px;
    border: 3px solid var(--fm-ink); border-radius: 999px;
    background: var(--fm-pink);
    color: var(--fm-ink); font-size: 13.5px; font-weight: 800; cursor: pointer;
    box-shadow: 0 4px 0 var(--fm-ink);
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .fm-empty button:hover { transform: translateY(-2px); box-shadow: 0 6px 0 var(--fm-ink); }

  /* ===== 帖子详情弹窗 ===== */
  .fm-modal-mask {
    position: fixed; inset: 0; z-index: 80;
    background: rgba(58, 58, 58, 0.4); backdrop-filter: blur(3px);
    display: grid; place-items: center; padding: 20px;
  }
  .fm-modal {
    width: min(600px, 100%); max-height: 85vh; overflow-y: auto;
    background: var(--fm-cream);
    border: 4px solid var(--fm-ink); border-radius: 24px;
    padding: 22px;
    box-shadow: 0 10px 0 rgba(58,58,58,0.7);
  }
  .fm-modal-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
  .fm-modal-head b { font-size: 18px; font-weight: 900; color: var(--fm-ink); }
  .fm-modal-close {
    font-style: normal; cursor: pointer; color: var(--fm-ink); font-size: 14px;
    width: 30px; height: 30px; display: grid; place-items: center; border-radius: 50%;
    background: var(--fm-pink); border: 2.5px solid var(--fm-ink);
  }
  .fm-modal-close:hover { background: var(--fm-pink-deep); color: #fff; }
  .fm-modal-meta { display: flex; align-items: center; gap: 10px; margin-top: 16px; }
  .fm-modal-meta b { font-size: 13.5px; color: var(--fm-ink); }
  .fm-modal-meta > span { font-size: 12px; color: #9aa5b5; }
  .fm-like-btn {
    margin-left: auto; font-family: var(--font); font-size: 12.5px; font-weight: 800;
    color: var(--fm-ink); background: var(--fm-pink);
    border: 2.5px solid var(--fm-ink);
    border-radius: 999px; padding: 5px 14px; cursor: pointer;
    box-shadow: 0 3px 0 var(--fm-ink);
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .fm-like-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 0 var(--fm-ink); }
  .fm-modal-content { margin-top: 16px; font-size: 14px; color: var(--fm-ink); line-height: 1.8; white-space: pre-wrap; font-weight: 500; }

  .fm-comments { margin-top: 22px; border-top: 3px dashed rgba(58,58,58,0.25); padding-top: 18px; }
  .fm-comments h4 { font-size: 14px; font-weight: 900; color: var(--fm-ink); }
  .fm-comment-list { margin-top: 12px; display: flex; flex-direction: column; gap: 14px; }
  .fm-comment { display: flex; gap: 10px; }
  .fm-comment-body b { font-size: 13px; color: var(--fm-pink-deep); font-weight: 900; }
  .fm-comment-body p { font-size: 13.5px; color: var(--fm-ink); line-height: 1.6; margin-top: 2px; font-weight: 500; }
  .fm-comment-time { font-size: 11.5px; color: #b3bcc9; font-weight: 600; }
  .fm-no-comment { text-align: center; padding: 24px; color: #9aa5b5; font-size: 13px; font-weight: 600; }
  .fm-comment-input { display: flex; gap: 10px; margin-top: 16px; }
  .fm-comment-input input {
    flex: 1; height: 44px; padding: 0 16px;
    border: 3px solid var(--fm-ink); border-radius: 999px;
    font-family: var(--font); font-size: 13.5px; font-weight: 600; color: var(--fm-ink);
    background: #fff;
  }
  .fm-comment-input input:focus { outline: none; box-shadow: 0 0 0 4px rgba(143,188,240,0.45); }
  .fm-comment-input button {
    flex: none; font-family: var(--font); font-size: 13.5px; font-weight: 800;
    color: var(--fm-ink); background: var(--fm-orange);
    border: 3px solid var(--fm-ink); border-radius: 999px; padding: 0 22px; cursor: pointer;
    box-shadow: 0 3px 0 var(--fm-ink);
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .fm-comment-input button:hover { transform: translateY(-2px); box-shadow: 0 5px 0 var(--fm-ink); }

  @media (max-width: 940px) {
    .fm-hero { flex-direction: column; align-items: flex-start; padding: 64px 22px 24px; gap: 14px; }
    .fm-mascot { display: none; }
    .fm-hero-actions { margin-left: 0; }
    .fm-body { padding: 20px; }
    .fm-deco { display: none; }
  }
</style>
