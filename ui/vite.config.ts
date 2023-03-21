import { loadEnv, defineConfig } from 'vite';
import reactRefresh from '@vitejs/plugin-react-refresh';
import { urbitPlugin } from '@urbit/vite-plugin-urbit';
import nodePolyfills from 'vite-plugin-node-stdlib-browser'
// import { Buffer } from "buffer";
// globalThis.Buffer = Buffer;

// https://vitejs.dev/config/
export default ({ mode }) => {
  Object.assign(process.env, loadEnv(mode, process.cwd()));
  const SHIP_URL = process.env.SHIP_URL || process.env.VITE_SHIP_URL || 'http://localhost:8080';
  console.log(SHIP_URL);

  return defineConfig({
    plugins: [urbitPlugin({ base: 'amm', target: SHIP_URL, secure: false }), reactRefresh(), nodePolyfills()],
    optimizeDeps: { esbuildOptions: { target: 'es2020'} }, // exclude: ['ipfs-http-client', 'electron-fetch', ]
    define: { "process.env.REACT_APP_MOCK_DATA": "true"},
  });
};
