import React, { useEffect, useState } from 'react';
import Urbit from '@urbit/http-api';
import useAmmStore from './store/ammStore';
import { AccountSelector, useWalletStore } from '@uqbar/wallet-ui'
import Pools from './components/Pools';
import Swap from './components/Swap';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export function App() {
  const { init } = useAmmStore()
  const { initWallet } = useWalletStore()

  useEffect(() => {
    init();
    initWallet({  });
  }, []);

  return (
    <div className="flex flex-row justify-center">
      <Swap />
      <Pools />
    </div>
  );
}
