import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './App.css';
import api from "./templates/api";
import useStore from './templates/store/store';
import Pools from './templates/components/Pools';
import { forEachChild } from 'typescript';

function App() {
  const { init, getPoolPoke, testPoke, poolValue } = useStore();

  useEffect(() => {
    init()
    getPoolPoke()

  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // const poolData = {
  //   'name': 'testpool',
  //   'liq-shares': 1000,
  //   'liq-token-meta': '0x1',
  //   'our-liq-token-account': '0x2',
  //   'token-a': {
  //     'name': 'token-a',
  //     'symbol': 'TKA',
  //     'metadata': '0x3',
  //     'our-account': '0x4',
  //     'pool-account': '0x5',
  //     'liquidity': 1000,
  //     'current-price': 50
  //   },
  //   'token-b': {
  //     'name': 'token-b',
  //     'symbol': 'TKB',
  //     'metadata': '0x6',
  //     'our-account': '0x7',
  //     'pool-account': '0x8',
  //     'liquidity': 2000,
  //     'current-price': 80    
  //   },
  // }

  // function addPoolPoke() {
  //   api.poke({app: 'amm', mark: 'amm-action', json: {'make-pool': poolData}})
  // }

  function tokenPoke(token: string, amount: number) {
    api.poke({ app: 'amm', mark: 'amm-action', json: { 'token-in': { token, amount } } })
  }

  return (
    <div className="App">
      <header className="App-header">
        <p>
          Get Some Tokens:
        </p>
        <form
        onSubmit={(e: React.SyntheticEvent) => {
          e.preventDefault();
          const target = e.target as typeof e.target & {
            token: { value: string };
            amount: { value: number };
          };
          const token = target.token.value;
          const amount = target.amount.value;
          tokenPoke(token, Number(amount));
        }}
      >
        <input
          type="token"
          name="token"
          placeholder="Token Name"
        />
        <br/>
        <input
          type="amount"
          name="amount"
          placeholder="Amount"
        />
        <br/>
        <input type="submit" value="Send It" />
      </form>
      <br/>
      {/* <form
      onSubmit={(e: React.SyntheticEvent) => {
        e.preventDefault();
        getPoolPoke();
      }}
      >
        <input type="submit" value="Log Test Pool"/>
      </form> */}
      <Pools pools={poolValue}/>
      </header>
    </div>
  );
}

export default App;
