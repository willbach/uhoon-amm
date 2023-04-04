import { useWalletStore } from '@uqbar/wallet-ui';
import Decimal from 'decimal.js';
import React, { useState, useMemo } from 'react';
import { addDecimalDots, AMM_ADDRESS, removeDots, TEN_18 } from '../constants';
import useAmmStore from '../store/ammStore';
import './styles/Tokens.scss';


const Allowances = () => {
  const { tokens, account, allow } = useAmmStore()

  const { setInsetView, metadata, assets} = useWalletStore()

  const [token1, setToken1] = React.useState('choose token')
  const [allow1, setAllow1] = React.useState('')

  // this one is from wallet rather than pools. good for allowances, not for balances
  const tokensList = useMemo(() => {
    if (!account) return [];

    const listTokens = Object.entries(assets[account] || {})
      .filter(([, value]) => value.token_type === 'token')
      .map(([key, value]) => {
        return { meta: value.data?.metadata, balance: value.data?.balance };
      });

    return listTokens;
  }, [account, assets]);



  const handleAllow = () => {
    const allowance = addDecimalDots(new Decimal(allow1).mul(TEN_18).toFixed(0))

    const jon = {
      "set-allowance": {
        token: {
          meta: token1,
          amount: allowance,
        }
      }
    }

    allow(jon)
    console.log('jon: ', jon)
    setInsetView('confirm-most-recent')
  }

  return (
    <div className="tokens-component">
      <h1>allowances</h1>

      <div className="token-input">
        <select className="select" value={token1} onChange={(e) => setToken1(e.target.value)}>
          <option value={'token1'} key='first-option1'></option>
          {tokensList.map((t, i) => (
            <option value={t.meta} key={'option1-' + i}>
               {metadata[t.meta]?.data?.name}: {new Decimal(removeDots(t.balance || '0')).div(TEN_18).toFixed(1)}
            </option>
          ))}
        </select>


        <input type='number' placeholder='set allowance to amm' value={allow1} onChange={(e) => setAllow1(e.target.value)} />

        <div className="current-allowance">
          <span>current allowance: {new Decimal(removeDots(tokens?.[token1]?.['our-account'].allowances?.[AMM_ADDRESS] || '0')).div(TEN_18).toFixed(0)}</span>
        </div>

        <button className='button' onClick={handleAllow}>SET</button>
      </div>

    </div>
  )
}

export default Allowances