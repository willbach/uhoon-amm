import Decimal from 'decimal.js'
import React, { useEffect, useMemo, useState } from 'react'
import { addDecimalDots, removeDots, splitString, TEN_18 } from '../constants'
import useAmmStore from '../store/ammStore'

const Swap = () => {
  const { pools, tokens, swap } = useAmmStore()

  const [token1, setToken1] = useState<string>('token2')
  const [token2, setToken2] = useState<string>('token2')

  const [amount1, setAmount1] = useState<string>('')
  const [amount2, setAmount2] = useState<string>('')

  const [slippage, setSlippage] = useState<number>(3)

  // let us examine what is needed to calculate a swap. 


  const handleSwitchDir = () => {
    const temp1 = token1

    setToken1(token2)
    setToken2(temp1)

    const tem1 = amount1
    
    setAmount1(amount2)
    setAmount2(tem1)
    // todo, dynamic pricing, 
  }

  const handleSwap = () => {
    const payment = addDecimalDots((new Decimal(amount1).mul(TEN_18)).toString())
    const receive = addDecimalDots((new Decimal(amount2).mul(TEN_18)).toString())
  

    // pools work both ways
    let poolid: string 
    if (!pools[`${token1}/${token2}`]?.address) {
      poolid = pools[`${token2}/${token1}`].address
    } else {
      poolid = pools[`${token1}/${token2}`].address
    }
    
    
    console.log('t1, t2: ', token1, token2)
    console.log('p, r, pid: ', payment, receive, poolid)

    const json = {
      swap: {
        payment: {meta: token1, amount: payment},
        receive: {meta: token2, amount: receive},
        "pool-id": poolid,
      }
    }

    //swap(json)
  } 


  return (
    <div className=''>
      <div className='flex'>
        <select value={token1} onChange={(e) => setToken1(e.target.value)}>
          <option value={'token1'}></option>
          {tokens && tokens.map((t, i) => <option value={t.metadata}>{t.name} {(new Decimal(removeDots(t['our-account'].balance)).div(TEN_18)).toFixed(2)}</option>)}
          
        </select>

        <input type='number' placeholder='amount' value={amount1} onChange={(e) => setAmount1(e.target.value)} />

      </div>
      <button onClick={handleSwitchDir}>{'<-->'}</button>
      <div className='flex'>
        <select value={token2} onChange={(e) => setToken2(e.target.value)}>
          <option value={'token2'}></option>
          {tokens && tokens.map((t, i) => <option value={t.metadata}>{t.name} {(new Decimal(removeDots(t['our-account'].balance)).div(TEN_18)).toFixed(2)}</option>)}
        </select>

        <input type='number' placeholder='amount' value={amount2} onChange={(e) => setAmount2(e.target.value)} />

      </div>

      <button onClick={handleSwap}>swap</button>

    </div>
  )
}

export default Swap