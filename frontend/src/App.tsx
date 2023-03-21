import React, { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Link } from "react-router-dom";
import { AccountSelector, useWalletStore } from '@uqbar/wallet-ui';
import { Swap, Pools } from './components'
import './App.scss'
import useAmmStore from './store/ammStore';

function App() {
  const { initWallet } = useWalletStore()
  const { init } = useAmmStore()
  useEffect(() => {
    (async () => {

      init()
      initWallet({ prompt: true })

    })()
  }, [])


  return (
    <BrowserRouter basename={'/apps/amm'}>
      {/* <Navbar /> */}
      <div>
        <Link to='/'>/swap</Link>
        <Link to='/pools'>/pools</Link>
        <Link to='/tokens'>/tokens</Link>
      </div>
      <AccountSelector />

      <Routes>
        <Route path="/" element={<Swap />} />
        <Route path="/pools" element={<Pools />} />
        <Route path="/tokens" element={<div>hay</div>} />
        <Route
          path="*"
          element={
            <main style={{ padding: "1rem" }}>
              <p>There's nothing here!</p>
            </main>
          }
        />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
