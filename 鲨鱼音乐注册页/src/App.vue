<script setup>
import { ref, computed, onMounted } from 'vue'
import shark from './assets/shark-mascot.jpg'

const account = ref('')
const password = ref('')
const showPassword = ref(false)
const remember = ref(false)
const toastMsg = ref('')
let toastTimer = null

/* 背景漂浮泡泡 / 珍珠 */
const pearls = ref([])
onMounted(() => {
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
})

const colors = ['#ff8fa3', '#f5c86a', '#7fc8a9', '#5aa9f0']
const texts = ['太弱啦', '还可以', '挺不错', '非常安全']

const strength = computed(() => {
  const v = password.value
  let s = 0
  if (v.length >= 8) s++
  if (/[a-zA-Z]/.test(v) && /\d/.test(v)) s++
  if (/[^a-zA-Z0-9]/.test(v) && v.length >= 10) s++
  if (v.length >= 12 && /[A-Z]/.test(v)) s++
  return v ? Math.max(1, s) : 0
})

function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}

function submit() {
  if (!account.value.trim()) return toast('请输入账户')
  if (password.value.length < 8) return toast('密码至少 8 位，再想一想 🧋')
  if (remember.value) {
    try { localStorage.setItem('shark_remember', account.value) } catch (e) {}
  }
  toast('注册成功！欢迎加入鲨鱼音乐 🦈🎵')
  setTimeout(() => {
    account.value = ''
    password.value = ''
    if (remember.value) remember.value = false
  }, 700)
}

function social(name) {
  toast('使用 ' + name + ' 登录（演示）')
}

function forgot() {
  toast('找回密码演示：我们会向绑定邮箱发送验证码 📮')
}

function placeholderLink() {
  toast('演示页面，链接暂未接入')
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

  <main class="shell">
    <!-- ================= 左：主视觉 ================= -->
    <section class="stage">
      <div class="brand">
        <div class="brand-mark">
          <svg viewBox="0 0 24 24" fill="none" stroke="#2f3238" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 13c0-3.5 3-6 7-6 2 0 3.6.6 5 1.7L20 6v11l-4-2.7C14.6 15.4 13 16 11 16c-4 0-7-1.5-7-3z" fill="#eaf2fe"/>
            <circle cx="8" cy="11.4" r=".9" fill="#2f3238" stroke="none"/>
            <path d="M10.5 14.5c1.4.9 3 .9 4.4 0" />
          </svg>
        </div>
        <div class="brand-text">
          <b>鲨鱼音乐</b>
          <span>SHARK MUSIC</span>
        </div>
      </div>

      <div class="mascot-wrap">
        <div class="mascot-halo"></div>
        <img class="mascot" :src="shark" alt="喝珍珠奶茶的小鲨鱼" />

        <div class="floaty n1">
          <svg width="42" height="42" viewBox="0 0 24 24" fill="none" stroke="#2f3238" stroke-width="2" stroke-linecap="round">
            <circle cx="7" cy="18" r="3" fill="#ff9eb0"/>
            <circle cx="18" cy="15.5" r="3" fill="#a9c8f0"/>
            <path d="M10 18V7l11-2.5v10.5"/>
          </svg>
        </div>
        <div class="floaty n2">
          <svg width="36" height="36" viewBox="0 0 24 24" fill="none">
            <ellipse cx="12" cy="14" rx="7" ry="8" fill="#c9a26b" stroke="#2f3238" stroke-width="2"/>
            <ellipse cx="9.5" cy="11.5" rx="2" ry="2.6" fill="#fff" opacity=".55"/>
          </svg>
        </div>
        <div class="floaty n3">
          <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#2f3238" stroke-width="2" stroke-linecap="round">
            <path d="M9 18V6l9-2v12" />
            <circle cx="6.5" cy="18" r="2.6" fill="#f5c86a"/>
            <circle cx="15.5" cy="16" r="2.6" fill="#ffd6dd"/>
          </svg>
        </div>
      </div>

      <div class="tagline">
        <h2>吸一口珍珠奶茶，<em>跟着鲨鲨一起摇摆</em> 🎧</h2>
        <p>千万曲库 · 无损音质 · 每日为你推荐</p>
        <div class="chips">
          <span class="chip">🎵 无损音质</span>
          <span class="chip pink">🦈 独家歌单</span>
          <span class="chip">🧋 听歌领奶茶</span>
        </div>
      </div>
    </section>

    <!-- ================= 右：注册表单 ================= -->
    <section class="panel">
      <h1>创建<span>新账号</span></h1>
      <p class="sub">加入鲨鱼音乐，开启你的音乐之旅 🎶</p>

      <form @submit.prevent="submit">
        <div class="field">
          <label for="account">账户</label>
          <div class="control">
            <svg viewBox="0 0 24 24" fill="none" stroke="#7fa9e2" stroke-width="2" stroke-linecap="round">
              <circle cx="12" cy="8" r="3.6"/><path d="M4.5 19.5c1.4-3.6 4.2-5 7.5-5s6.1 1.4 7.5 5"/>
            </svg>
            <input id="account" type="text" v-model="account" placeholder="手机号 / 邮箱 / 用户名" autocomplete="username" />
          </div>
        </div>

        <div class="field">
          <label for="password">密码</label>
          <div class="control">
            <svg viewBox="0 0 24 24" fill="none" stroke="#7fa9e2" stroke-width="2" stroke-linecap="round">
              <rect x="4.5" y="10" width="15" height="10" rx="3"/><path d="M8 10V7.5a4 4 0 018 0V10"/>
            </svg>
            <input id="password" :type="showPassword ? 'text' : 'password'" v-model="password" placeholder="请输入密码（至少 8 位）" autocomplete="new-password" />
            <button type="button" class="toggle" @click="showPassword = !showPassword">{{ showPassword ? '隐藏' : '显示' }}</button>
          </div>
          <div class="meter">
            <i v-for="n in 4" :key="n" :style="{ background: n <= strength ? colors[strength - 1] : '#e6ecf5' }"></i>
          </div>
          <div class="meter-hint" :style="{ color: password ? colors[strength - 1] : 'var(--ink-soft)' }">
            密码强度：{{ password ? texts[strength - 1] : '待输入' }}
          </div>

          <div class="row-options">
            <label class="check">
              <input type="checkbox" v-model="remember" />
              <span class="box">
                <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.2 4.2L19 6.6"/></svg>
              </span>
              <span>自动登录</span>
            </label>
            <a class="forgot" href="#" @click.prevent="forgot">忘记密码？</a>
          </div>
        </div>

        <button class="btn-primary" type="submit">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2f3238" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 4h3a2 2 0 012 2v12a2 2 0 01-2 2h-3"/>
            <path d="M10 16l4-4-4-4"/>
            <path d="M14 12H3"/>
          </svg>
          注 册
        </button>

        <div class="divider"><span>或 使 用</span></div>

        <div class="socials">
          <button type="button" class="social" title="微信" @click="social('微信')">
            <svg viewBox="0 0 24 24"><path fill="#2f3238" d="M9.2 3C5.2 3 2 5.7 2 9c0 1.9 1 3.6 2.7 4.7l-.7 2.2 2.5-1.3c.8.2 1.7.4 2.6.4h.5a5.6 5.6 0 01-.2-1.5c0-3 3-5.4 6.6-5.4h.5C15.8 5 12.8 3 9.2 3zm-2.5 3.9a1 1 0 110 2 1 1 0 010-2zm5 0a1 1 0 110 2 1 1 0 010-2zM22 13.6c0-2.8-2.8-5-6.2-5s-6.2 2.2-6.2 5 2.8 5 6.2 5c.7 0 1.4-.1 2.1-.3l2 1-.6-1.8c1.6-.9 2.7-2.3 2.7-3.9zm-8.2-1.2a.85.85 0 110-1.7.85.85 0 010 1.7zm4.3 0a.85.85 0 110-1.7.85.85 0 010 1.7z"/></svg>
          </button>
          <button type="button" class="social" title="QQ" @click="social('QQ')">
            <svg viewBox="0 0 24 24"><path fill="#2f3238" d="M12 2c3.1 0 5.2 2.3 5.2 5.6 0 .9.5 1.4 1 2.4.7 1.3 1.3 2.6 1.3 4.4 0 1-.4 1.7-1 1.7-.5 0-.9-.4-1.2-1-.4 1.3-1.4 2.4-2.8 3l.4 1c.1.4-.2.9-.7.9h-4.4c-.5 0-.8-.5-.7-.9l.4-1c-1.4-.6-2.4-1.7-2.8-3-.3.6-.7 1-1.2 1-.6 0-1-.7-1-1.7 0-1.8.6-3.1 1.3-4.4.5-1 1-1.5 1-2.4C6.8 4.3 8.9 2 12 2z"/></svg>
          </button>
          <button type="button" class="social" title="Apple" @click="social('Apple')">
            <svg viewBox="0 0 24 24"><path fill="#2f3238" d="M16.4 12.7c0-2.2 1.8-3.3 1.9-3.3-1-1.5-2.6-1.7-3.2-1.7-1.4-.1-2.7.8-3.4.8-.7 0-1.8-.8-2.9-.8-1.5 0-2.9.9-3.7 2.2-1.6 2.7-.4 6.7 1.1 8.9.7 1.1 1.6 2.3 2.7 2.2 1.1 0 1.5-.7 2.8-.7s1.7.7 2.9.7c1.2 0 2-1.1 2.7-2.2.9-1.2 1.2-2.4 1.2-2.5-.1 0-2.3-.9-2.3-3.4zM14.2 6.3c.6-.8 1-1.8.9-2.9-.9 0-2 .6-2.6 1.4-.6.7-1.1 1.8-.9 2.8 1 .1 2-.5 2.6-1.3z"/></svg>
          </button>
        </div>

        <p class="foot">已经有账号了？<a href="#" @click.prevent="placeholderLink">立即登录</a></p>
      </form>
    </section>
  </main>

  <div class="toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
</template>

<style>
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
      "Nunito", system-ui, -apple-system, "Segoe UI", sans-serif;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: var(--font);
    min-height: 100vh;
    background: radial-gradient(1200px 700px at 15% 10%, #ffffff 0%, var(--page) 45%, #e4eefc 100%);
    color: var(--ink);
    display: grid;
    place-items: center;
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

  .shell {
    position: relative;
    z-index: 1;
    width: min(1180px, 100%);
    background: rgba(255, 255, 255, 0.72);
    backdrop-filter: blur(14px);
    border: var(--stroke) solid var(--ink);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-card), 8px 8px 0 rgba(47, 50, 56, 0.9);
    display: grid;
    grid-template-columns: 1.06fr 1fr;
    overflow: hidden;
    min-height: 660px;
  }

  .stage {
    position: relative;
    padding: 46px 44px;
    background: linear-gradient(165deg, #dcebfd 0%, #eaf3fe 48%, #f6eef6 100%);
    border-right: var(--stroke) dashed rgba(47, 50, 56, 0.28);
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  .stage::before {
    content: "";
    position: absolute;
    width: 340px; height: 340px;
    right: -110px; top: -110px;
    background: radial-gradient(circle, rgba(255, 158, 176, 0.28), transparent 70%);
    border-radius: 50%;
  }

  .brand { display: flex; align-items: center; gap: 12px; position: relative; z-index: 2; }
  .brand-mark {
    width: 46px; height: 46px;
    border: var(--stroke) solid var(--ink);
    border-radius: 15px;
    background: linear-gradient(150deg, var(--shark-blue), var(--shark-blue-deep));
    display: grid; place-items: center;
    box-shadow: 3px 3px 0 var(--ink);
  }
  .brand-mark svg { width: 26px; height: 26px; }
  .brand-text b { font-size: 19px; letter-spacing: 0.5px; display: block; }
  .brand-text span { font-size: 11px; color: var(--ink-soft); letter-spacing: 2.4px; font-weight: 700; }

  .mascot-wrap {
    position: relative;
    flex: 1;
    display: grid;
    place-items: center;
    padding: 14px 0 4px;
    z-index: 2;
  }
  .mascot-halo {
    position: absolute;
    width: 320px; height: 320px;
    border-radius: 50%;
    background: radial-gradient(circle at 50% 45%, rgba(169, 200, 240, 0.55), rgba(169, 200, 240, 0) 68%);
    animation: pulse 5s ease-in-out infinite;
  }
  @keyframes pulse {
    0%,100% { transform: scale(1); opacity: .9; }
    50%     { transform: scale(1.07); opacity: 1; }
  }
  .mascot {
    width: min(330px, 82%);
    border-radius: 44% 56% 50% 50% / 50% 48% 52% 50%;
    border: var(--stroke) solid var(--ink);
    box-shadow: 10px 12px 0 var(--ink);
    animation: bob 4.2s ease-in-out infinite;
    background: #fff;
    display: block;
  }
  @keyframes bob {
    0%, 100% { transform: translateY(0) rotate(-1deg); }
    50%      { transform: translateY(-16px) rotate(1.4deg); }
  }

  .floaty { position: absolute; z-index: 3; animation: floatY 6s ease-in-out infinite; }
  .floaty.n1 { top: 20%; left: 6%; animation-delay: .2s; }
  .floaty.n2 { bottom: 24%; right: 8%; animation-delay: 1.1s; }
  .floaty.n3 { top: 40%; right: 2%; animation-delay: .7s; }

  .tagline {
    position: relative; z-index: 2;
    background: var(--white);
    border: var(--stroke) solid var(--ink);
    border-radius: var(--radius-md);
    padding: 16px 18px;
    box-shadow: 5px 5px 0 var(--ink);
  }
  .tagline h2 { font-size: 20px; line-height: 1.35; }
  .tagline h2 em { font-style: normal; color: var(--pink); }
  .tagline p { margin-top: 6px; font-size: 13px; color: var(--ink-soft); font-weight: 600; }
  .chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
  .chip {
    font-size: 11.5px; font-weight: 800; color: var(--ink);
    background: var(--shark-blue-soft);
    border: 2px solid var(--ink);
    border-radius: 999px;
    padding: 5px 11px;
  }
  .chip.pink { background: var(--pink-soft); }

  .panel {
    padding: 46px 46px 40px;
    background: linear-gradient(180deg, #ffffff 0%, #fbfdff 100%);
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  .panel h1 { font-size: 30px; letter-spacing: 0.4px; }
  .panel h1 span { color: var(--shark-blue-deep); }
  .panel .sub { margin-top: 8px; font-size: 13.5px; color: var(--ink-soft); font-weight: 600; }

  form { margin-top: 26px; }
  .field { margin-bottom: 16px; }
  .field label {
    display: block; font-size: 12.5px; font-weight: 800;
    margin-bottom: 7px; color: var(--ink);
    letter-spacing: 0.3px;
  }
  .control {
    display: flex; align-items: center; gap: 10px;
    background: #fff;
    border: var(--stroke) solid var(--ink);
    border-radius: var(--radius-sm);
    padding: 0 14px;
    height: 52px;
    transition: box-shadow .18s ease, transform .18s ease, background .18s ease;
  }
  .control:focus-within {
    background: #f7fbff;
    box-shadow: 4px 4px 0 var(--shark-blue);
    transform: translate(-1px, -1px);
  }
  .control svg { width: 20px; height: 20px; flex: none; opacity: .85; }
  .control input {
    flex: 1; border: 0; outline: 0; background: transparent;
    font-family: var(--font); font-size: 14.5px; font-weight: 600; color: var(--ink);
    height: 100%;
  }
  .control input::placeholder { color: #a9b1bd; font-weight: 600; }
  .toggle {
    border: 0; background: transparent; cursor: pointer;
    font-size: 12px; font-weight: 800; color: var(--shark-blue-deep);
    padding: 6px; border-radius: 8px;
  }
  .toggle:hover { background: var(--shark-blue-soft); }

  .meter { display: flex; gap: 6px; margin-top: 8px; }
  .meter i {
    height: 7px; flex: 1; border-radius: 99px;
    background: #e6ecf5; border: 2px solid rgba(47,50,56,.25);
    transition: background .25s ease;
  }
  .meter-hint { font-size: 11.5px; font-weight: 700; color: var(--ink-soft); margin-top: 6px; height: 14px; }

  .btn-primary {
    width: 100%; height: 54px; margin-top: 6px;
    font-family: var(--font); font-size: 16px; font-weight: 800; color: var(--ink);
    background: linear-gradient(140deg, var(--shark-blue) 0%, var(--shark-blue-deep) 100%);
    border: var(--stroke) solid var(--ink); border-radius: var(--radius-sm);
    box-shadow: 5px 5px 0 var(--ink);
    cursor: pointer; letter-spacing: 1px;
    transition: transform .12s ease, box-shadow .12s ease, filter .12s ease;
    display: flex; align-items: center; justify-content: center; gap: 9px;
  }
  .btn-primary:hover { filter: brightness(1.05); transform: translate(-1px,-1px); box-shadow: 7px 7px 0 var(--ink); }
  .btn-primary:active { transform: translate(4px,4px); box-shadow: 1px 1px 0 var(--ink); }

  .divider { display: flex; align-items: center; gap: 14px; margin: 22px 0 16px; }
  .divider::before, .divider::after { content: ""; flex: 1; height: 2px; background: repeating-linear-gradient(90deg, #cfd9e8 0 7px, transparent 7px 14px); }
  .divider span { font-size: 11.5px; font-weight: 800; color: var(--ink-soft); letter-spacing: 1px; }

  .socials { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
  .social {
    height: 48px; border: var(--stroke) solid var(--ink); border-radius: var(--radius-sm);
    background: #fff; cursor: pointer; display: grid; place-items: center;
    box-shadow: 3px 3px 0 var(--ink);
    transition: transform .12s ease, box-shadow .12s ease, background .15s ease;
  }
  .social:hover { background: var(--cream); transform: translate(-1px,-1px); box-shadow: 4px 4px 0 var(--ink); }
  .social:active { transform: translate(3px,3px); box-shadow: 1px 1px 0 var(--ink); }
  .social svg { width: 22px; height: 22px; }

  .foot { margin-top: 20px; text-align: center; font-size: 13px; font-weight: 700; color: var(--ink-soft); }
  .foot a { color: var(--ink); font-weight: 800; text-decoration: none; border-bottom: 2px solid var(--pink); }

  .row-options { display: flex; align-items: center; margin-top: 14px; }
  .check {
    display: inline-flex; align-items: center; gap: 8px; cursor: pointer;
    font-size: 12.5px; font-weight: 700; color: var(--ink-soft);
    user-select: none; position: relative;
  }
  .check input { position: absolute; opacity: 0; width: 0; height: 0; }
  .check .box {
    width: 18px; height: 18px; flex: none;
    border: 2.5px solid var(--ink); border-radius: 6px; background: #fff;
    display: grid; place-items: center;
    transition: background .15s ease, transform .12s ease;
  }
  .check .box svg { width: 12px; height: 12px; opacity: 0; transition: opacity .15s ease; }
  .check input:checked + .box { background: var(--shark-blue-deep); }
  .check input:checked + .box svg { opacity: 1; }
  .check:hover .box { transform: translateY(-1px); }
  .forgot {
    margin-left: auto; font-size: 12.5px; font-weight: 800;
    color: var(--shark-blue-deep); text-decoration: none;
  }
  .forgot:hover { color: var(--ink); border-bottom: 2px solid var(--pink); }

  .toast {
    position: fixed; left: 50%; bottom: 34px; transform: translate(-50%, 130%);
    background: var(--ink); color: #fff; font-weight: 700; font-size: 13.5px;
    padding: 13px 22px; border-radius: 999px; z-index: 20;
    transition: transform .35s cubic-bezier(.2,.9,.3,1.4);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,.5);
  }
  .toast.show { transform: translate(-50%, 0); }

  @media (max-width: 940px) {
    .shell { grid-template-columns: 1fr; min-height: 0; }
    .stage { border-right: 0; border-bottom: var(--stroke) dashed rgba(47,50,56,.28); padding: 32px 26px; }
    .mascot { width: min(240px, 62%); }
    .panel { padding: 32px 26px 30px; }
    .panel h1 { font-size: 25px; }
  }
  @media (max-width: 420px) {
    body { padding: 14px; }
    .socials { grid-template-columns: repeat(3, 1fr); }
    .panel h1 { font-size: 22px; }
  }
</style>
