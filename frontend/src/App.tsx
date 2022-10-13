import React, { useEffect } from 'react';
import logo from './logo.svg';
import './App.css';
import api from "./templates/api";
import useStore from './templates/store/store';

function App() {
  const { init, testPoke } = useStore();

  useEffect(() => {
    init()
    // testPoke()
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

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
      </header>
    </div>
  );
}

export default App;
