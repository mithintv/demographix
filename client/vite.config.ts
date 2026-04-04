import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import path from "path";
import { defineConfig, loadEnv } from "vite";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
	const env = loadEnv(mode, process.cwd());
	return {
		plugins: [react(), tailwindcss()],
		resolve: {
			alias: {
				"@": path.resolve(__dirname, "./src"),
			},
		},
		server: {
			proxy: {
				// Proxy any request starting with /api to the target server
				"/api": {
					target: env.VITE_API_HOSTNAME,
					changeOrigin: true, // Needed for virtual hosted sites
					rewrite: (path) => path.replace(/^\/api/, ""), // Remove /api prefix
				},
			},
		},
	};
});
