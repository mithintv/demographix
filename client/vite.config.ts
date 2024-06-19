import react from '@vitejs/plugin-react'
import { defineConfig, loadEnv } from 'vite'

// https://vitejs.dev/config/
export default defineConfig(({ command, mode, isSsrBuild, isPreview }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const sharedConfig = { plugins: [react()] }
  if (command === "serve") {
    return {
      ...sharedConfig,
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
    }
  } else return {
    ...sharedConfig,
    server: {
      proxy: {
        // Proxy any request starting with /api to the target server
        '/api': {
          target: JSON.stringify(env.API_HOSTNAME),  // Your API server
          changeOrigin: true,  // Needed for virtual hosted sites
          rewrite: (path) => path.replace(/^\/api/, ''),  // Remove /api prefix
        },
      }
    }
  }
})
