<script setup>
import { ref } from 'vue'
import shark from '../assets/shark-mascot.jpg'

const account = ref('')
const password = ref('')
const showPassword = ref(false)
const toastMsg = ref('')
let toastTimer = null

function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}

async function submit() {
  const acc = account.value.trim()
  if (!acc) return toast('请输入管理员账号')
  if (!password.value) return toast('请输入密码')

  try {
    const res = await fetch('/api/admin/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ account: acc, password: password.value })
    })
    const data = await res.json().catch(() => ({}))
    if (res.ok) {
      const token = (data.data && data.data.token) || ''
      try { localStorage.setItem('shark_admin_token', token) } catch (e) {}
      toast('管理员登录成功，正在进入后台 🛠️')
      password.value = ''
      setTimeout(() => { location.hash = '#/admin' }, 600)
    } else if (res.status === 401) {
      toast(data.message || '管理员账号或密码错误')
    } else {
      toast(data.message || '登录失败，请稍后再试')
    }
  } catch (e) {
    toast('无法连接服务器，请确认后端已启动 (8081) 🔌')
  }
}

function backHome() {
  location.hash = '#/home'
}
</script>

<template>
  <main class="admin-shell">
    <!-- ================= 左：主视觉 ================= -->
    <section class="admin-stage">
      <div class="admin-brand">
        <div class="admin-brand-mark">
          <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 13c0-3.5 3-6 7-6 2 0 3.6.6 5 1.7L20 6v11l-4-2.7C14.6 15.4 13 16 11 16c-4 0-7-1.5-7-3z" fill="rgba(255,255,255,.25)"/>
            <circle cx="8" cy="11.4" r=".9" fill="#fff" stroke="none"/>
            <path d="M10.5 14.5c1.4.9 3 .9 4.4 0" />
          </svg>
        </div>
        <div class="admin-brand-text">
          <b>鲨鱼音乐 · 后台</b>
          <span>ADMIN CONSOLE</span>
        </div>
      </div>

      <div class="admin-mascot-wrap">
        <div class="admin-mascot-halo"></div>
        <img class="admin-mascot" :src="shark" alt="喝珍珠奶茶的小鲨鱼" />
        <div class="admin-badge">🛠 内容管理中枢</div>
      </div>

      <div class="admin-tagline">
        <h2>管理首页展示内容，<em>让鲨鲨的曲库更精彩</em> 🎧</h2>
        <p>歌曲 · 歌单 · 榜单 · 歌手 · 频道 · 听书，统一管理</p>
        <div class="admin-chips">
          <span class="admin-chip">🎵 曲库维护</span>
          <span class="admin-chip alt">📊 数据看板</span>
          <span class="admin-chip">⚡ 即时生效</span>
        </div>
      </div>
    </section>

    <!-- ================= 右：登录表单（仅登录，无注册） ================= -->
    <section class="admin-panel">
      <h1>管理员登录<span>欢迎回来，管理员</span></h1>
      <p class="admin-sub">请输入管理员账号密码以进入后台管理系统</p>

      <form @submit.prevent="submit">
        <div class="admin-field">
          <label for="admin-account">管理员账号</label>
          <div class="admin-control">
            <svg viewBox="0 0 24 24" fill="none" stroke="#f97316" stroke-width="2" stroke-linecap="round">
              <circle cx="12" cy="8" r="3.6"/><path d="M4.5 19.5c1.4-3.6 4.2-5 7.5-5s6.1 1.4 7.5 5"/>
            </svg>
            <input id="admin-account" type="text" v-model="account" placeholder="请输入管理员账号" autocomplete="username" />
          </div>
        </div>

        <div class="admin-field">
          <label for="admin-password">密码</label>
          <div class="admin-control">
            <svg viewBox="0 0 24 24" fill="none" stroke="#f97316" stroke-width="2" stroke-linecap="round">
              <rect x="4.5" y="10" width="15" height="10" rx="3"/><path d="M8 10V7.5a4 4 0 018 0V10"/>
            </svg>
            <input id="admin-password" :type="showPassword ? 'text' : 'password'" v-model="password" placeholder="请输入密码" autocomplete="current-password" />
            <button type="button" class="admin-toggle" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button>
          </div>
        </div>

        <button class="admin-btn" type="submit">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 4h3a2 2 0 012 2v12a2 2 0 01-2 2h-3"/>
            <path d="M10 16l4-4-4-4"/>
            <path d="M14 12H3"/>
          </svg>
          登 录 后 台
        </button>

        <p class="admin-foot">
          <a href="#/home" @click.prevent="backHome">← 返回官网首页</a>
        </p>
        <p class="admin-tip">本页面仅提供登录功能，注册请前往用户端 🐟</p>
      </form>
    </section>
  </main>

  <div class="admin-toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
</template>

<style scoped>
  .admin-shell {
    position: relative;
    z-index: 1;
    width: min(1080px, 100%);
    margin: 0 auto;
    background: rgba(255, 255, 255, 0.92);
    backdrop-filter: blur(14px);
    border: var(--stroke) solid var(--ink);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-card), 8px 8px 0 rgba(47, 50, 56, 0.9);
    display: grid;
    grid-template-columns: 1.05fr 1fr;
    overflow: hidden;
    min-height: 600px;
  }

  .admin-stage {
    position: relative;
    padding: 44px 42px;
    background: linear-gradient(165deg, #ffb37a 0%, #ff8a5c 42%, #ef4444 100%);
    border-right: var(--stroke) dashed rgba(47, 50, 56, 0.28);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    color: #fff;
  }
  .admin-stage::before {
    content: "";
    position: absolute;
    width: 320px; height: 320px;
    right: -110px; top: -110px;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.3), transparent 70%);
    border-radius: 50%;
  }

  .admin-brand { display: flex; align-items: center; gap: 12px; position: relative; z-index: 2; }
  .admin-brand-mark {
    width: 46px; height: 46px;
    border: var(--stroke) solid var(--ink);
    border-radius: 15px;
    background: rgba(255, 255, 255, 0.22);
    display: grid; place-items: center;
    box-shadow: 3px 3px 0 var(--ink);
  }
  .admin-brand-mark svg { width: 26px; height: 26px; }
  .admin-brand-text b { font-size: 19px; letter-spacing: 0.5px; display: block; text-shadow: 1px 1px 0 rgba(47,50,56,.25); }
  .admin-brand-text span { font-size: 11px; letter-spacing: 2.4px; font-weight: 700; opacity: .9; }

  .admin-mascot-wrap {
    position: relative; flex: 1;
    display: grid; place-items: center; padding: 14px 0 4px; z-index: 2;
  }
  .admin-mascot-halo {
    position: absolute; width: 300px; height: 300px; border-radius: 50%;
    background: radial-gradient(circle at 50% 45%, rgba(255,255,255,.6), rgba(255,255,255,0) 68%);
    animation: adminPulse 5s ease-in-out infinite;
  }
  @keyframes adminPulse { 0%,100% { transform: scale(1); opacity:.9 } 50% { transform: scale(1.07); opacity:1 } }
  .admin-mascot {
    width: min(300px, 80%);
    border-radius: 44% 56% 50% 50% / 50% 48% 52% 50%;
    border: var(--stroke) solid var(--ink);
    box-shadow: 10px 12px 0 var(--ink);
    animation: adminBob 4.2s ease-in-out infinite; background: #fff; display: block;
  }
  @keyframes adminBob { 0%,100% { transform: translateY(0) rotate(-1deg) } 50% { transform: translateY(-16px) rotate(1.4deg) } }
  .admin-badge {
    position: absolute; bottom: 6%; left: 50%; transform: translateX(-50%);
    background: var(--ink); color: #fff; font-weight: 800; font-size: 12.5px;
    padding: 7px 14px; border-radius: 999px; box-shadow: 0 8px 18px rgba(0,0,0,.3);
    white-space: nowrap;
  }

  .admin-tagline {
    position: relative; z-index: 2;
    background: rgba(255,255,255,.16);
    border: 2px solid rgba(255,255,255,.5);
    border-radius: var(--radius-md); padding: 16px 18px;
    backdrop-filter: blur(4px);
  }
  .admin-tagline h2 { font-size: 19px; line-height: 1.35; text-shadow: 1px 1px 0 rgba(47,50,56,.2); }
  .admin-tagline h2 em { font-style: normal; color: #fff3c4; }
  .admin-tagline p { margin-top: 6px; font-size: 13px; font-weight: 600; opacity: .95; }
  .admin-chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
  .admin-chip {
    font-size: 11.5px; font-weight: 800; color: var(--ink);
    background: #fff; border: 2px solid var(--ink); border-radius: 999px; padding: 5px 11px;
    box-shadow: 2px 2px 0 var(--ink);
  }
  .admin-chip.alt { background: #fff3c4; }

  .admin-panel {
    padding: 50px 46px 40px;
    background: linear-gradient(180deg, #ffffff 0%, #fff7f2 100%);
    display: flex; flex-direction: column; justify-content: center;
  }
  .admin-panel h1 { font-size: 28px; letter-spacing: 0.4px; }
  .admin-panel h1 span { color: #ef4444; }
  .admin-sub { margin-top: 8px; font-size: 13.5px; color: var(--ink-soft); font-weight: 600; }

  form { margin-top: 26px; }
  .admin-field { margin-bottom: 16px; }
  .admin-field label {
    display: block; font-size: 12.5px; font-weight: 800; margin-bottom: 7px;
    color: var(--ink); letter-spacing: 0.3px;
  }
  .admin-control {
    display: flex; align-items: center; gap: 10px;
    background: #fff; border: var(--stroke) solid var(--ink); border-radius: var(--radius-sm);
    padding: 0 14px; height: 52px;
    transition: box-shadow .18s ease, transform .18s ease, background .18s ease;
  }
  .admin-control:focus-within { background: #fffaf4; box-shadow: 4px 4px 0 #f97316; transform: translate(-1px,-1px); }
  .admin-control svg { width: 20px; height: 20px; flex: none; opacity: .85; }
  .admin-control input {
    flex: 1; border: 0; outline: 0; background: transparent;
    font-family: var(--font); font-size: 14.5px; font-weight: 600; color: var(--ink); height: 100%;
  }
  .admin-control input::placeholder { color: #a9b1bd; font-weight: 600; }
  .admin-toggle {
    border: 0; background: transparent; cursor: pointer; font-size: 12px; font-weight: 800;
    color: #ef4444; padding: 6px; border-radius: 8px;
  }
  .admin-toggle:hover { background: #ffe9e0; }

  .admin-btn {
    width: 100%; height: 54px; margin-top: 6px;
    font-family: var(--font); font-size: 16px; font-weight: 800; color: #fff;
    background: linear-gradient(140deg, #f97316 0%, #ef4444 100%);
    border: var(--stroke) solid var(--ink); border-radius: var(--radius-sm);
    box-shadow: 5px 5px 0 var(--ink);
    cursor: pointer; letter-spacing: 1px;
    transition: transform .12s ease, box-shadow .12s ease, filter .12s ease;
    display: flex; align-items: center; justify-content: center; gap: 9px;
  }
  .admin-btn:hover { filter: brightness(1.05); transform: translate(-1px,-1px); box-shadow: 7px 7px 0 var(--ink); }
  .admin-btn:active { transform: translate(4px,4px); box-shadow: 1px 1px 0 var(--ink); }

  .admin-foot { margin-top: 20px; text-align: center; font-size: 13px; font-weight: 700; }
  .admin-foot a { color: var(--ink); text-decoration: none; border-bottom: 2px solid #f97316; }
  .admin-tip { margin-top: 10px; text-align: center; font-size: 11.5px; font-weight: 600; color: var(--ink-soft); }

  .admin-toast {
    position: fixed; left: 50%; bottom: 34px; transform: translate(-50%, 130%);
    background: var(--ink); color: #fff; font-weight: 700; font-size: 13.5px;
    padding: 13px 22px; border-radius: 999px; z-index: 20;
    transition: transform .35s cubic-bezier(.2,.9,.3,1.4);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,.5);
  }
  .admin-toast.show { transform: translate(-50%, 0); }

  @media (max-width: 940px) {
    .admin-shell { grid-template-columns: 1fr; min-height: 0; }
    .admin-stage { border-right: 0; border-bottom: var(--stroke) dashed rgba(47,50,56,.28); padding: 32px 26px; }
    .admin-mascot { width: min(220px, 60%); }
    .admin-panel { padding: 32px 26px 30px; }
  }
</style>
