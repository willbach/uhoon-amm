import React, { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Link } from "react-router-dom";
import { AccountSelector, useWalletStore } from '@uqbar/wallet-ui';
import { Swap, Pools, Tokens, Navbar } from './components'
import './App.scss'
import useAmmStore from './store/ammStore';

function App() {
  const initWallet = useWalletStore(state => state.initWallet)
  const init  = useAmmStore(state => state.init)
  

  useEffect(() => {
    (async () => {
      init()
      initWallet({ prompt: true })
    })()
  }, [])
  
  return (
    <BrowserRouter basename={'/apps/amm'}>
      <Navbar />
      <Routes>
        <Route path="/" element={<Swap />} />
        <Route path="/pools" element={<Pools />} />
        <Route path="/tokens" element={<Tokens />} />
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
