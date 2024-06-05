import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
     // Proxy any request starting with /api to the target server
      '/api': {
        target: 'http://localhost:5000',  // Your API server
        changeOrigin: true,  // Needed for virtual hosted sites
        rewrite: (path) => path.replace(/^\/api/, ''),  // Remove /api prefix
      },
    }
  }
})
