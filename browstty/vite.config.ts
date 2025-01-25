import path from "node:path";
import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import tailwindcss from '@tailwindcss/vite';

// https://vite.dev/config/
export default defineConfig({
    plugins: [tailwindcss(), svelte()],
    resolve: {
        alias: {
            "$": path.resolve(__dirname, "src")
        }
    }
});
