import React from 'react'
import api from '../api'
import { AMM_ADDRESS, FUNGIBLE_ADDRESS, removeDots, TEN_18, addDecimalDots } from '../constants'
import Decimal from 'decimal.js'
import useAmmStore from '../store/ammStore'
import { useWalletStore } from '@uqbar/wallet-ui'

const Tokens = () => {
  // (deploy tokens) and set their allowance for test
  // probably add this to /swap, figure out how much we want to look/feel like uniswap

  const tokens = useAmmStore(state => state.tokens)
  const allow = useAmmStore(state => state.allow)
  const setInsetView = useWalletStore(state => state.setInsetView)

  const [token1, setToken1] = React.useState('choose token')
  const [allow1, setAllow1] = React.useState('')

  const handleDeploy = async () => {
    console.log('deploy poke res: ')
  }

  const handleAllow = () => {
    const allowance = addDecimalDots(new Decimal(allow1).mul(TEN_18).toString())

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

  return tokens && (
    <div>
      <h1>Tokens</h1>

      <div className=''>
        <select value={token1} onChange={(e) => setToken1(e.target.value)}>
          <option value={'token1'} key='first-option1'></option>
          {tokens && Object.values(tokens).map((t, i) => <option value={t.metadata} key={'option1-' + i}>{t.name} {(new Decimal(removeDots(t['our-account'].balance || '0')).div(TEN_18)).toFixed(2)} </option>)}

        </select>


        <input type='number' placeholder='set allowance to amm' value={allow1} onChange={(e) => setAllow1(e.target.value)} />

      </div>
      <div>
        <span>current allowance: {new Decimal(removeDots(tokens?.[token1]?.['our-account'].allowances?.[AMM_ADDRESS] || '0'))?.div(TEN_18)?.toFixed(2)}</span>
      </div>
      <button onClick={handleAllow}>SET</button>


    </div>
  )
}

export default Tokens