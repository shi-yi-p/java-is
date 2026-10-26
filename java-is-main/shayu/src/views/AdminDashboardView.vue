<script setup>
import { ref, reactive, computed, onMounted } from 'vue'

/* 后端接口走 Vite 开发代理（同源 /api → 127.0.0.1:8081） */
const API = ''

/* ============ 管理员 token 校验 ============ */
const token = ref('')
try { token.value = localStorage.getItem('shark_admin_token') || '' } catch (e) {}
if (!token.value) location.hash = '#/admin-login'

function jwtAccount(t) {
  try {
    const p = t.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')
    const j = JSON.parse(decodeURIComponent(escape(atob(p))))
    return j.sub || j.account || ''
  } catch (e) { return '' }
}
const account = ref(jwtAccount(token.value))

function authHeaders() {
  return { 'Content-Type': 'application/json', Authorization: 'Bearer ' + token.value }
}

const toastMsg = ref('')
let toastTimer = null
function toast(m) {
  toastMsg.value = m
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMsg.value = ''), 2600)
}

/* ============ 模块配置 ============ */
const TONE_OPTIONS = ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8']
const TONE_MAP = TONE_OPTIONS.map(v => ({ v, t: v }))
const TREND_OPTIONS = [
  { v: 'up', t: '↑ 上升' },
  { v: 'down', t: '↓ 下降' },
  { v: 'flat', t: '— 持平' },
  { v: 'new', t: '新 新进' }
]
function trendText(v) {
  const o = TREND_OPTIONS.find(t => t.v === v)
  return o ? o.t : v
}

const MODULES = [
  { key: 'song', name: '歌曲', icon: '🎵', fields: [
    { k: 'title', label: '歌曲名' },
    { k: 'artist', label: '歌手' },
    { k: 'album', label: '专辑' },
    { k: 'duration', label: '时长(秒)', type: 'number' },
    { k: 'plays', label: '播放量', type: 'number' }
  ]},
  { key: 'playlist', name: '歌单', icon: '📃', fields: [
    { k: 'title', label: '标题' },
    { k: 'subtitle', label: '副标题' },
    { k: 'tag', label: '标签' },
    { k: 'icon', label: '图标' },
    { k: 'tone', label: '配色', type: 'select', options: TONE_MAP },
    { k: 'plays', label: '播放量', type: 'number' },
    { k: 'sortOrder', label: '排序', type: 'number' }
  ]},
  { key: 'chart', name: '榜单', icon: '🏆', fields: [
    { k: 'name', label: '榜单名' },
    { k: 'tone', label: '配色', type: 'select', options: TONE_MAP },
    { k: 'sortOrder', label: '排序', type: 'number' }
  ]},
  { key: 'singer', name: '歌手', icon: '🎤', fields: [
    { k: 'name', label: '歌手名' },
    { k: 'tab', label: '地区', type: 'select', options: [{ v: '华语', t: '华语' }, { v: '欧美', t: '欧美' }, { v: '日韩', t: '日韩' }] },
    { k: 'fans', label: '粉丝数', type: 'number' },
    { k: 'tone', label: '配色', type: 'select', options: TONE_MAP },
    { k: 'sortOrder', label: '排序', type: 'number' }
  ]},
  { key: 'channel', name: '频道', icon: '📻', fields: [
    { k: 'name', label: '频道名' },
    { k: 'icon', label: '图标' },
    { k: 'tone', label: '配色', type: 'select', options: TONE_MAP },
    { k: 'listeners', label: '在听人数', type: 'number' },
    { k: 'sortOrder', label: '排序', type: 'number' }
  ]},
  { key: 'audiobook', name: '听书', icon: '📚', fields: [
    { k: 'title', label: '标题' },
    { k: 'author', label: '主播' },
    { k: 'intro', label: '简介' },
    { k: 'tab', label: '分类', type: 'select', options: [{ v: '热门', t: '热门' }, { v: '小说', t: '小说' }, { v: '儿童', t: '儿童' }, { v: '相声', t: '相声' }, { v: '情感', t: '情感' }] },
    { k: 'icon', label: '图标' },
    { k: 'tone', label: '配色', type: 'select', options: TONE_MAP },
    { k: 'listens', label: '收听量', type: 'number' },
    { k: 'sortOrder', label: '排序', type: 'number' }
  ]}
]

const activeKey = ref('song')
const activeModule = computed(() => MODULES.find(m => m.key === activeKey.value))

const rows = ref([])
const loading = ref(false)

async function loadList() {
  loading.value = true
  try {
    const res = await fetch(API + '/api/admin/' + activeKey.value, { headers: authHeaders() })
    if (res.status === 401) {
      try { localStorage.removeItem('shark_admin_token') } catch (e) {}
      location.hash = '#/admin-login'
      return
    }
    const d = await res.json().catch(() => ({}))
    rows.value = (res.ok && Array.isArray(d.data)) ? d.data : []
  } catch (e) {
    toast('加载失败，请确认后端已启动 🔌')
    rows.value = []
  } finally {
    loading.value = false
  }
}

function switchModule(k) {
  activeKey.value = k
  showSongs.value = false
  songManageChartId.value = null
  loadList()
}

/* ============ 新增 / 编辑 ============ */
const showForm = ref(false)
const editing = ref(null)
const form = reactive({})

function openCreate() {
  const f = {}
  activeModule.value.fields.forEach(fld => { f[fld.k] = '' })
  editing.value = null
  Object.assign(form, f)
  showForm.value = true
}
function openEdit(row) {
  const f = {}
  activeModule.value.fields.forEach(fld => { f[fld.k] = row[fld.k] ?? '' })
  f.id = row.id
  editing.value = row
  Object.assign(form, f)
  showForm.value = true
}
async function save() {
  const payload = {}
  activeModule.value.fields.forEach(fld => {
    let v = form[fld.k]
    if (fld.type === 'number') v = (v === '' || v == null) ? null : Number(v)
    payload[fld.k] = v
  })
  if (editing.value) payload.id = editing.value.id
  try {
    const res = await fetch(API + '/api/admin/' + activeKey.value, {
      method: editing.value ? 'PUT' : 'POST',
      headers: authHeaders(),
      body: JSON.stringify(payload)
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast(editing.value ? '更新成功 ✅' : '新增成功 ✅'); showForm.value = false; loadList() }
    else toast(d.message || '保存失败')
  } catch (e) { toast('网络错误，请确认后端已启动 🔌') }
}
async function remove(row) {
  if (!confirm('确定删除该记录？此操作会逻辑删除。')) return
  try {
    const res = await fetch(API + '/api/admin/' + activeKey.value + '/' + row.id, {
      method: 'DELETE', headers: authHeaders()
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast('删除成功 🗑️'); loadList() } else toast(d.message || '删除失败')
  } catch (e) { toast('网络错误 🔌') }
}

/* ============ 榜单歌曲管理 ============ */
const showSongs = ref(false)
const songManageChartId = ref(null)
const chartSongs = ref([])
const songForm = reactive({ rankNo: '', title: '', artist: '', trend: 'flat' })
const songEditing = ref(null)

async function openSongs(row) {
  songManageChartId.value = row.id
  showSongs.value = true
  songEditing.value = null
  await loadSongs()
}
async function loadSongs() {
  const res = await fetch(API + '/api/admin/chart-songs?chartId=' + songManageChartId.value, { headers: authHeaders() })
  const d = await res.json().catch(() => ({}))
  chartSongs.value = (res.ok && Array.isArray(d.data)) ? d.data : []
}
function openSongCreate() {
  songForm.rankNo = ''; songForm.title = ''; songForm.artist = ''; songForm.trend = 'flat'
  songEditing.value = null
}
function openSongEdit(s) {
  Object.assign(songForm, { rankNo: s.rankNo, title: s.title, artist: s.artist, trend: s.trend })
  songEditing.value = s
}
async function saveSong() {
  const payload = {
    chartId: songManageChartId.value,
    rankNo: songForm.rankNo === '' ? null : Number(songForm.rankNo),
    title: songForm.title,
    artist: songForm.artist,
    trend: songForm.trend
  }
  if (songEditing.value) payload.id = songEditing.value.id
  try {
    const res = await fetch(API + '/api/admin/chart-songs', {
      method: songEditing.value ? 'PUT' : 'POST',
      headers: authHeaders(),
      body: JSON.stringify(payload)
    })
    const d = await res.json().catch(() => ({}))
    if (res.ok) { toast('已保存 ✅'); songEditing.value = null; await loadSongs() }
    else toast(d.message || '保存失败')
  } catch (e) { toast('网络错误 🔌') }
}
async function removeSong(s) {
  if (!confirm('从该榜单移除这首歌曲？')) return
  const res = await fetch(API + '/api/admin/chart-songs/' + s.id, { method: 'DELETE', headers: authHeaders() })
  if (res.ok) { toast('已移除 🗑️'); await loadSongs() } else toast('移除失败')
}

function logout() {
  try { localStorage.removeItem('shark_admin_token') } catch (e) {}
  location.hash = '#/admin-login'
  toast('已退出后台 👋')
}

function fmtNum(n) {
  const v = Number(n) || 0
  if (v >= 100000000) return (v / 100000000).toFixed(1).replace(/\.0$/, '') + '亿'
  if (v >= 10000) return (v / 10000).toFixed(1).replace(/\.0$/, '') + '万'
  return String(v)
}

onMounted(loadList)
</script>

<template>
  <div class="admin-app">
    <!-- ============ 顶栏 ============ -->
    <header class="admin-top">
      <div class="admin-logo">🛠 鲨鱼音乐 · 后台管理系统</div>
      <div class="admin-user">
        <span class="admin-who">👤 {{ account || '管理员' }}</span>
        <button class="admin-out" @click="logout">退出</button>
      </div>
    </header>

    <div class="admin-body">
      <!-- ============ 侧边模块导航 ============ -->
      <aside class="admin-side">
        <button
          v-for="m in MODULES"
          :key="m.key"
          class="admin-side-item"
          :class="{ active: activeKey === m.key }"
          @click="switchModule(m.key)"
        >
          <span class="admin-side-ico">{{ m.icon }}</span>{{ m.name }}
        </button>
      </aside>

      <!-- ============ 主内容 ============ -->
      <main class="admin-main">
        <div class="admin-head">
          <h2>{{ activeModule.name }}管理</h2>
          <button class="admin-add" @click="openCreate">＋ 新增{{ activeModule.name }}</button>
        </div>

        <div class="admin-table-wrap">
          <table class="admin-table">
            <thead>
              <tr>
                <th v-for="f in activeModule.fields" :key="f.k">{{ f.label }}</th>
                <th class="op">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in rows" :key="row.id">
                <td v-for="f in activeModule.fields" :key="f.k">
                  <span v-if="f.type === 'number'">{{ fmtNum(row[f.k]) }}</span>
                  <span v-else>{{ row[f.k] }}</span>
                </td>
                <td class="op">
                  <button class="lnk" @click="openEdit(row)">编辑</button>
                  <button class="lnk del" @click="remove(row)">删除</button>
                  <button v-if="activeKey === 'chart'" class="lnk song" @click="openSongs(row)">歌曲</button>
                </td>
              </tr>
              <tr v-if="!rows.length">
                <td :colspan="activeModule.fields.length + 1" class="empty">暂无数据，点击右上角「新增」添加一条吧～</td>
              </tr>
            </tbody>
          </table>
        </div>
      </main>
    </div>

    <!-- ============ 新增 / 编辑 模态 ============ -->
    <div v-if="showForm" class="admin-mask" @click.self="showForm = false">
      <div class="admin-modal">
        <h3>{{ editing ? '编辑' + activeModule.name : '新增' + activeModule.name }}</h3>
        <div class="admin-form">
          <div class="admin-fld" v-for="f in activeModule.fields" :key="f.k">
            <label>{{ f.label }}</label>
            <select v-if="f.type === 'select'" v-model="form[f.k]">
              <option v-for="o in f.options" :key="o.v" :value="o.v">{{ o.t }}</option>
            </select>
            <input v-else :type="f.type === 'number' ? 'number' : 'text'" v-model="form[f.k]" :placeholder="f.label" />
          </div>
        </div>
        <div class="admin-modal-foot">
          <button class="admin-cancel" @click="showForm = false">取消</button>
          <button class="admin-save" @click="save">保存</button>
        </div>
      </div>
    </div>

    <!-- ============ 榜单歌曲管理 模态 ============ -->
    <div v-if="showSongs" class="admin-mask" @click.self="showSongs = false">
      <div class="admin-modal wide">
        <h3>榜单歌曲管理</h3>
        <div class="admin-song-add">
          <input v-model="songForm.rankNo" type="number" placeholder="名次" />
          <input v-model="songForm.title" placeholder="歌曲名" />
          <input v-model="songForm.artist" placeholder="歌手" />
          <select v-model="songForm.trend">
            <option v-for="t in TREND_OPTIONS" :key="t.v" :value="t.v">{{ t.t }}</option>
          </select>
          <button class="admin-save sm" @click="saveSong">{{ songEditing ? '更新' : '加入榜单' }}</button>
          <button v-if="songEditing" class="admin-cancel sm" @click="openSongCreate">取消</button>
        </div>
        <table class="admin-table">
          <thead><tr><th>名次</th><th>歌曲</th><th>歌手</th><th>趋势</th><th class="op">操作</th></tr></thead>
          <tbody>
            <tr v-for="s in chartSongs" :key="s.id">
              <td>{{ s.rankNo }}</td>
              <td>{{ s.title }}</td>
              <td>{{ s.artist }}</td>
              <td>{{ trendText(s.trend) }}</td>
              <td class="op">
                <button class="lnk" @click="openSongEdit(s)">编辑</button>
                <button class="lnk del" @click="removeSong(s)">移除</button>
              </td>
            </tr>
            <tr v-if="!chartSongs.length"><td colspan="5" class="empty">该榜单暂无歌曲</td></tr>
          </tbody>
        </table>
        <div class="admin-modal-foot"><button class="admin-cancel" @click="showSongs = false">关闭</button></div>
      </div>
    </div>

    <div class="admin-toast" :class="{ show: toastMsg }">{{ toastMsg }}</div>
  </div>
</template>

<style scoped>
  .admin-app {
    position: fixed; inset: 0; z-index: 5;
    display: flex; flex-direction: column;
    background: linear-gradient(180deg, #eef4fe 0%, #e4eefc 100%);
    font-family: var(--font);
    color: var(--ink);
  }

  .admin-top {
    flex: none; height: 60px;
    display: flex; align-items: center; justify-content: space-between;
    padding: 0 26px;
    background: linear-gradient(90deg, #0b7efc 0%, #0a6ce0 100%);
    color: #fff;
    box-shadow: 0 2px 10px rgba(11, 126, 252, 0.3);
  }
  .admin-logo { font-size: 17px; font-weight: 800; letter-spacing: 0.5px; }
  .admin-user { display: flex; align-items: center; gap: 14px; }
  .admin-who { font-size: 13.5px; font-weight: 700; }
  .admin-out {
    font-family: var(--font); font-size: 12px; font-weight: 800; color: #fff;
    background: rgba(255,255,255,.16); border: 1px solid rgba(255,255,255,.5);
    border-radius: 999px; padding: 5px 14px; cursor: pointer;
  }
  .admin-out:hover { background: rgba(255,255,255,.3); }

  .admin-body { flex: 1; display: flex; min-height: 0; }

  .admin-side {
    flex: none; width: 190px; padding: 18px 12px;
    background: #fff; border-right: 1px solid #e6eefb;
    display: flex; flex-direction: column; gap: 6px; overflow-y: auto;
  }
  .admin-side-item {
    display: flex; align-items: center; gap: 10px;
    font-family: var(--font); font-size: 14px; font-weight: 700; color: #4a5568;
    background: none; border: 0; border-radius: 12px;
    padding: 12px 14px; cursor: pointer; text-align: left;
    transition: background .15s ease, color .15s ease;
  }
  .admin-side-item:hover { background: #eef5ff; color: #0b7efc; }
  .admin-side-item.active { background: #0b7efc; color: #fff; box-shadow: 3px 3px 0 rgba(47,50,56,.25); }
  .admin-side-ico { font-size: 17px; }

  .admin-main { flex: 1; padding: 26px 30px; overflow-y: auto; }
  .admin-head {
    display: flex; align-items: center; justify-content: space-between;
    margin-bottom: 18px;
  }
  .admin-head h2 { font-size: 22px; font-weight: 800; }
  .admin-add {
    font-family: var(--font); font-size: 14px; font-weight: 800; color: #fff;
    background: linear-gradient(140deg, #0b7efc, #0a6ce0);
    border: 2px solid var(--ink); border-radius: 12px;
    padding: 10px 18px; cursor: pointer;
    box-shadow: 3px 3px 0 var(--ink);
    transition: transform .12s ease, box-shadow .12s ease;
  }
  .admin-add:hover { transform: translate(-1px,-1px); box-shadow: 5px 5px 0 var(--ink); }
  .admin-add:active { transform: translate(3px,3px); box-shadow: 1px 1px 0 var(--ink); }

  .admin-table-wrap {
    background: #fff; border: 1px solid #e6eefb; border-radius: 16px;
    overflow: hidden; box-shadow: 0 14px 30px -22px rgba(70,104,160,.5);
  }
  .admin-table { width: 100%; border-collapse: collapse; font-size: 13.5px; }
  .admin-table thead th {
    background: #f4f8ff; color: #4a5568; font-weight: 800; text-align: left;
    padding: 13px 14px; border-bottom: 2px solid #e6eefb; white-space: nowrap;
  }
  .admin-table tbody td {
    padding: 12px 14px; border-bottom: 1px solid #eef2f7;
    color: var(--ink); max-width: 220px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  .admin-table tbody tr:hover { background: #f8fbff; }
  .admin-table .op { width: 1%; white-space: nowrap; }
  .admin-table .empty { text-align: center; color: #8a94a6; font-weight: 600; padding: 40px 0; }

  .lnk {
    font-family: var(--font); font-size: 12.5px; font-weight: 800;
    border: 0; background: none; cursor: pointer; color: #0b7efc;
    padding: 4px 8px; border-radius: 8px;
  }
  .lnk:hover { background: #eef5ff; }
  .lnk.del { color: #ef4444; }
  .lnk.del:hover { background: #fde8e8; }
  .lnk.song { color: #f97316; }
  .lnk.song:hover { background: #fff0e6; }

  /* ============ 模态 ============ */
  .admin-mask {
    position: fixed; inset: 0; z-index: 30;
    background: rgba(15, 23, 42, 0.45);
    display: grid; place-items: center; padding: 20px;
  }
  .admin-modal {
    width: min(460px, 100%);
    background: #fff; border: 3px solid var(--ink); border-radius: 20px;
    box-shadow: 8px 8px 0 rgba(47,50,56,.9);
    padding: 24px 24px 20px;
  }
  .admin-modal.wide { width: min(720px, 100%); }
  .admin-modal h3 { font-size: 18px; font-weight: 800; margin-bottom: 16px; }
  .admin-form { display: flex; flex-direction: column; gap: 12px; max-height: 60vh; overflow-y: auto; }
  .admin-fld { display: flex; flex-direction: column; gap: 5px; }
  .admin-fld label { font-size: 12.5px; font-weight: 800; color: var(--ink); }
  .admin-fld input, .admin-fld select {
    font-family: var(--font); font-size: 14px; font-weight: 600; color: var(--ink);
    border: 2.5px solid var(--ink); border-radius: 12px; padding: 10px 12px;
    background: #fff; outline: 0;
  }
  .admin-fld input:focus, .admin-fld select:focus { background: #f7fbff; box-shadow: 3px 3px 0 var(--shark-blue); }

  .admin-modal-foot { display: flex; justify-content: flex-end; gap: 10px; margin-top: 18px; }
  .admin-cancel, .admin-save {
    font-family: var(--font); font-size: 14px; font-weight: 800;
    border: 2.5px solid var(--ink); border-radius: 12px; padding: 10px 20px; cursor: pointer;
  }
  .admin-cancel { background: #fff; color: var(--ink); box-shadow: 3px 3px 0 var(--ink); }
  .admin-cancel:hover { background: #f1f4f8; }
  .admin-save { background: linear-gradient(140deg, #0b7efc, #0a6ce0); color: #fff; box-shadow: 3px 3px 0 var(--ink); }
  .admin-save:hover { filter: brightness(1.05); }
  .admin-save.sm, .admin-cancel.sm { padding: 8px 14px; font-size: 13px; }

  .admin-song-add { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; }
  .admin-song-add input, .admin-song-add select {
    font-family: var(--font); font-size: 13px; font-weight: 600; color: var(--ink);
    border: 2.5px solid var(--ink); border-radius: 10px; padding: 8px 10px; background: #fff; outline: 0;
  }
  .admin-song-add input[type="number"] { width: 80px; }

  .admin-toast {
    position: fixed; left: 50%; bottom: 34px; transform: translate(-50%, 130%);
    background: var(--ink); color: #fff; font-weight: 700; font-size: 13.5px;
    padding: 13px 22px; border-radius: 999px; z-index: 40;
    transition: transform .35s cubic-bezier(.2,.9,.3,1.4);
    box-shadow: 0 12px 30px -10px rgba(0,0,0,.5);
  }
  .admin-toast.show { transform: translate(-50%, 0); }

  @media (max-width: 760px) {
    .admin-side { width: 120px; }
    .admin-side-item { font-size: 12.5px; padding: 10px; }
    .admin-side-ico { font-size: 15px; }
    .admin-main { padding: 18px 14px; }
  }
</style>
