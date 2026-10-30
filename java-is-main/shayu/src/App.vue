<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import LoginView from './views/LoginView.vue'
import HomeView from './views/HomeView.vue'
import AdminLoginView from './views/AdminLoginView.vue'
import AdminDashboardView from './views/AdminDashboardView.vue'

/* ============ 极简 hash 路由 ============
 * #/login  登录页
 * #/home   首页
 * #/rank        榜单页      ┐ 都由 HomeView 承载（共用顶栏/导航/播放器），
 * #/audiobook   听书页      │ HomeView 内部再按 hash 切换内容视图
 * #/live        直播页      ┘
 * #/admin-login、#/admin    后台管理
 * ======================================== */
const readToken = () => {
  try { return localStorage.getItem('shark_token') || '' } catch (e) { return '' }
}
const readAdminToken = () => {
  try { return localStorage.getItem('shark_admin_token') || '' } catch (e) { return '' }
}

/* 由首页外壳承载的子页面 */
const HOME_PAGES = ['home', 'rank', 'audiobook', 'live']

/* 归一化：rank/audiobook 也由 HomeView 渲染，避免落到模板兜底分支 */
const toView = r => (HOME_PAGES.includes(r) ? 'home' : r)

function resolveRoute() {
  const h = location.hash.replace(/^#\/?/, '').split('?')[0]
  if (h === 'admin' || h === 'admin-login') return h        /* 后台管理 */
  if (h === 'login') return h
  if (HOME_PAGES.includes(h)) return h
  return readToken() ? 'home' : 'login'   /* 默认：有 token 进首页，否则进登录页 */
}

const route = ref(toView(resolveRoute()))

function applyRoute() {
  let r = resolveRoute()
  if (r === 'admin' && !readAdminToken()) r = 'admin-login'   /* 未登录访问后台 → 回后台登录页 */
  if (HOME_PAGES.includes(r) && !readToken()) r = 'login'     /* 未登录访问首页/榜单/听书 → 回登录页 */
  route.value = toView(r)                                     /* 统一交给 HomeView 渲染 */
  const target = '#/' + r
  if (location.hash !== target) location.hash = target
}

onMounted(() => {
  window.addEventListener('hashchange', applyRoute)
  applyRoute()
})
onUnmounted(() => window.removeEventListener('hashchange', applyRoute))

/* 背景漂浮泡泡 / 珍珠（登录页 / 首页共用） */
const pearls = ref([])
{
  const conf = [
    { x: 6,  y: 14, s: 46, c: '' },
    { x: 88, y: 10, s: 30, c: 'pink' },
    { x: 14, y: 74, s: 26, c: 'pink' },
    { x: 78, y: 68, s: 54, c: 'blob' },
    { x: 46, y: 4,  s: 20, c: '' },
    { x: 92, y: 44, s: 22, c: '' },
    { x: 2,  y: 46, s: 34, c: 'blob' },
    { x: 62, y: 90, s: 24, c: 'pink' },
    { x: 34, y: 88, s: 30, c: '' }
  ]
  pearls.value = conf.map((o, i) => ({ ...o, delay: (i * 0.45) + 's' }))
}
</script>

<template>
  <div class="bg-deco">
    <div
      v-for="(p, i) in pearls"
      :key="i"
      class="pearl"
      :class="p.c"
      :style="{ left: p.x + 'vw', top: p.y + 'vh', width: p.s + 'px', height: p.s + 'px', animationDelay: p.delay }"
    ></div>
  </div>

  <LoginView v-if="route === 'login'" />
  <HomeView v-else-if="route === 'home'" />
  <AdminLoginView v-else-if="route === 'admin-login'" />
  <AdminDashboardView v-else />
</template>

<style>
  /* ===== 全局共享：设计变量 / 背景 / 珍珠 / toast（登录页与首页同款） ===== */
  :root {
    --shark-blue: #a9c8f0;
    --shark-blue-deep: #7fa9e2;
    --shark-blue-soft: #dbe8fb;
    --ink: #2f3238;
    --ink-soft: #6b7078;
    --pink: #ff9eb0;
    --pink-soft: #ffd6dd;
    --boba: #c9a26b;
    --boba-deep: #ab8552;
    --cream: #fdf6ec;
    --yellow: #f5c86a;
    --white: #ffffff;
    --page: #eef4fe;
    --radius-lg: 32px;
    --radius-md: 20px;
    --radius-sm: 14px;
    --stroke: 3px;
    --shadow-soft: 0 18px 40px -18px rgba(80, 116, 175, 0.45);
    --shadow-card: 0 30px 70px -30px rgba(70, 104, 160, 0.55);
    --font: "Baloo 2", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei",
      "Nunito", system-ui, -apple-system, "Segoe UI", sans-serif,
      "Segoe UI Emoji", "Apple Color Emoji", "Noto Color Emoji";
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: var(--font);
    min-height: 100vh;
    background: radial-gradient(1200px 700px at 15% 10%, #ffffff 0%, var(--page) 45%, #e4eefc 100%);
    color: var(--ink);
    display: grid;
    place-items: safe center;
    padding: 28px;
    overflow-x: hidden;
    position: relative;
  }

  .bg-deco { position: fixed; inset: 0; pointer-events: none; z-index: 0; overflow: hidden; }
  .pearl {
    position: absolute;
    border-radius: 50%;
    background: radial-gradient(circle at 32% 30%, #ffffff 0%, var(--shark-blue) 60%, var(--shark-blue-deep) 100%);
    opacity: 0.5;
    animation: floatY 9s ease-in-out infinite;
  }
  .pearl.pink { background: radial-gradient(circle at 32% 30%, #fff 0%, var(--pink-soft) 60%, var(--pink) 100%); }
  .pearl.blob {
    border-radius: 46% 54% 55% 45% / 52% 44% 56% 48%;
    background: radial-gradient(circle at 30% 25%, #fff 0%, #eaf2fe 55%, #d3e3fb 100%);
    opacity: 0.75;
  }
  @keyframes floatY {
    0%, 100% { transform: translateY(0) scale(1); }
    50%      { transform: translateY(-26px) scale(1.04); }
  }

  .toast {
    position: fixed; left: 50%; bottom: 34px; transform: translate(-50%, 130%);
    background: var(--ink); color: #fff; font-weight: 700; font-size: 13.5px;
    padding: 13px 22px; border-radius: 999px; z-index: 20;
    transition: transform .35s cubic-bezier(.2,.9,.3,1.4);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,.5);
  }
  .toast.show { transform: translate(-50%, 0); }

  @media (max-width: 420px) {
    body { padding: 14px; }
  }
</style>
