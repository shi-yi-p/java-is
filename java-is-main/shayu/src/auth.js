/* ============================================================
 * 登录态统一封装（三级降级）
 *
 * 优先级：sessionStorage（每个标签页独立，支持多标签页登录不同账号）
 *       → localStorage（降级：sessionStorage 被浏览器禁用时兜底）
 *       → 内存变量（最终保底：所有存储都被禁时，至少当前会话可用）
 *
 * 写入策略：同时写 sessionStorage 和内存；sessionStorage 失败时写 localStorage。
 * 读取策略：sessionStorage → 内存 → localStorage（兼容改动前的旧 token）。
 * 这样无论浏览器存储策略如何，登录都不会"看似成功实则丢 token"。
 * ============================================================ */
const TOKEN_KEY = 'shark_token'
const ACCOUNT_KEY = 'shark_account'

/* 内存兜底（浏览器重启/刷新后丢失，仅作存储全禁时的会话内保底） */
const mem = { token: '', account: '' }

function safe(fn) {
  try { fn(); return true } catch (e) { return false }
}

function ssGet(k) { try { return window.sessionStorage.getItem(k) } catch (e) { return null } }
function ssSet(k, v) { return safe(() => { window.sessionStorage.setItem(k, v) }) }
function ssDel(k) { return safe(() => { window.sessionStorage.removeItem(k) }) }
function lsGet(k) { try { return window.localStorage.getItem(k) } catch (e) { return null } }
function lsSet(k, v) { return safe(() => { window.localStorage.setItem(k, v) }) }
function lsDel(k) { return safe(() => { window.localStorage.removeItem(k) }) }

/* ============ Token ============ */
export function getToken() {
  const s = ssGet(TOKEN_KEY)
  if (s) return s
  if (mem.token) return mem.token
  return lsGet(TOKEN_KEY) || ''
}

export function setToken(token) {
  const v = token || ''
  mem.token = v
  if (v) {
    /* sessionStorage 优先；成功则清掉 localStorage 旧残留（避免新标签页读到过期账号），
       失败（被禁/隐私模式）则降级 localStorage */
    if (ssSet(TOKEN_KEY, v)) lsDel(TOKEN_KEY)
    else lsSet(TOKEN_KEY, v)
  } else {
    ssDel(TOKEN_KEY)
    lsDel(TOKEN_KEY)
  }
}

export function clearToken() {
  mem.token = ''
  ssDel(TOKEN_KEY)
  lsDel(TOKEN_KEY)
}

/* ============ Account ============ */
export function getAccount() {
  const s = ssGet(ACCOUNT_KEY)
  if (s) return s
  if (mem.account) return mem.account
  return lsGet(ACCOUNT_KEY) || ''
}

export function setAccount(account) {
  const v = account || ''
  mem.account = v
  if (v) {
    if (ssSet(ACCOUNT_KEY, v)) lsDel(ACCOUNT_KEY)
    else lsSet(ACCOUNT_KEY, v)
  } else {
    ssDel(ACCOUNT_KEY)
    lsDel(ACCOUNT_KEY)
  }
}

/* 认证请求头（供各组件拼 Authorization 用） */
export function authHeaders() {
  const t = getToken()
  return t ? { Authorization: 'Bearer ' + t } : {}
}
