import React, { useEffect, useState } from 'react';
import Urbit from '@urbit/http-api';
import useAmmStore from './store/ammStore';
import Pools from './components/Pools';
import Swap from './components/Swap';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export function App() {
  const { init } = useAmmStore()


  useEffect(() => {
    init();

  }, []);

  return (
    <div className="flex flex-row justify-center">
      <Swap />
      <Pools />
    </div>
  );
}
