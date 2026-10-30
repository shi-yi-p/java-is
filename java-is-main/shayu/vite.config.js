import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: true,
    open: true,
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:8081',
        changeOrigin: true
      },
      // Navidrome / Subsonic API + 音频流：/navidrome/rest/... -> http://127.0.0.1:4533/rest/...
      '/navidrome': {
        target: 'http://127.0.0.1:4533',
        changeOrigin: true,
        rewrite: (p) => p.replace(/^\/navidrome/, '')
      }
    }
  }
})
