import { useWalletStore, AccountSelector } from '@uqbar/wallet-ui'
import Decimal from 'decimal.js'
import React, { useEffect, useMemo, useState } from 'react'
import { addDecimalDots, removeDots, splitString, TEN_18, AMM_ADDRESS } from '../constants'
import useAmmStore, { Pool } from '../store/ammStore'
import Txs from './Txs'

const Swap = () => {
  const { pools, tokens, swap } = useAmmStore()
  const { setInsetView } = useWalletStore()

  const [token1, setToken1] = useState<string>('token2')
  const [token2, setToken2] = useState<string>('token2')

  const [amount1, setAmount1] = useState<string>('')
  const [amount2, setAmount2] = useState<string>('')

  const [minimumReceived, setMinimumReceived] = useState<string>('')
  const [priceImpact, setPriceImpact] = useState<string>('')
  const [currentPrice, setCurrentPrice] = useState<string>('')

  const [slippage, setSlippage] = useState<string>('3')
  
  const handleAmountChange1 = (e: any | undefined) => {
    if (!e && !amount1) return
    const amountA = new Decimal(!e ? amount1 : e.target.value)
    setAmount1(amountA.toString())

    const pool = getPool()


    // need to know which one is token-a and token-b, todo -> foolproof
    const t1 = token1 === pool['token-a'].metadata ? pool['token-a'] : pool['token-b']
    const t2 = token2 === pool['token-b'].metadata ? pool['token-b'] : pool['token-a']

    const price2 = new Decimal(removeDots(t2['current-price']))

    const slippageMultiplier = new Decimal(100).minus(slippage).div(100)

    const noslippageamount2 = price2.mul(amountA).div(TEN_18)
    const tokenamount2 = price2.mul(amountA).mul(slippageMultiplier).div(TEN_18).toFixed(3)

    //  K = 10000 = (X + 10) * (Y + delta_b)  
    
    // include 18 decimals in calc? they'll be there in the Decimals I hope
    const liqA = new Decimal(removeDots(t1.liquidity)).div(TEN_18)
    const liqB = new Decimal(removeDots(t2.liquidity)).div(TEN_18)

    const k = liqA.mul(liqB)
    
    const amountB = (k.div(liqA.plus(amountA))).minus(liqB)


    const priceIm = (noslippageamount2.div(amountB)).abs().minus(1).abs().mul(100)
    const minreceived = amountB.mul(slippageMultiplier).abs()
    
    // todo, store t1 and t2 in state and operate on those instead
    // currently won't update as state updates... nested state mayb the problem? 
    setCurrentPrice(price2.div(TEN_18).toFixed(3))

    setMinimumReceived(minreceived.toFixed(3))
    setPriceImpact(priceIm.toFixed(2))
    setAmount2(amountB.abs().toFixed(3))

  }

  const handleSetSlippage = (e: any) => {
    setSlippage(e.target.value)
    handleAmountChange1(undefined)
  }

  const getPool = () => {
    let pool: Pool;
    if (!pools[`${token1}/${token2}`]?.address) {
      pool = pools[`${token2}/${token1}`]
    } else {
      pool = pools[`${token1}/${token2}`]
    }
    return pool
  }


  const handleSwitchDir = () => {
    const temp1 = token1

    setToken1(token2)
    setToken2(temp1)

    const tem1 = amount1

    setAmount1(amount2)
    setAmount2(tem1)

    handleAmountChange1(undefined)
  }

  // write a handlePriceChange(token1, token2).
  // handleTokensChange(token1, token2) also works 

  const handleSwap = async () => {
    const payment = addDecimalDots((new Decimal(amount1).mul(TEN_18)).toString())
    const receive = addDecimalDots((new Decimal(minimumReceived).mul(TEN_18)).toString())

    
    const pool = getPool()

    const json = {
      swap: {
        payment: { meta: token1, amount: payment },
        receive: { meta: token2, amount: receive },
        "pool-id": pool.address,
      }
    }
    console.log('poke', json)
    await swap(json)

    setInsetView('confirm-most-recent')
  }

  useEffect(() => {
    handleAmountChange1(undefined)
    console.log('ass')
  }, [pools, tokens])

  return (
    <div className=''>
        <span>current price: 1 {tokens[token1]?.name} = {currentPrice} {tokens[token2]?.name}</span>

      <div className='flex'>
        <select value={token1} onChange={(e) => setToken1(e.target.value)}>
          <option value={'token1'} key='first-option1'></option>
          {tokens && Object.values(tokens).map((t, i) => <option value={t.metadata} key={'option1-' + i}>{t.name} {(new Decimal(removeDots(t['our-account'].balance)).div(TEN_18)).toFixed(2)} </option>)}

        </select>

        <input type='number' placeholder='amount' value={amount1} onChange={handleAmountChange1} />

      </div>

  
      <button onClick={handleSwitchDir}>{'<-->'}</button>
      <div className='flex'>
        <select value={token2} onChange={(e) => setToken2(e.target.value)}>
          <option value={'token2'}></option>
          {tokens && Object.values(tokens).map((t, i) => <option value={t.metadata} key={'option2-' + i}>{t.name} {(new Decimal(removeDots(t['our-account'].balance)).div(TEN_18)).toFixed(2)}</option>)}
        </select>

        <input type='number' placeholder='amount' value={amount2} onChange={(e) => setAmount2(e.target.value)} />
      </div>

      <div>
        <span>price-impact: {priceImpact}%</span>
      </div>

      <div>
        <span>minimum received: {minimumReceived}</span>
      </div>

      <div className='flex'>
        <span>slippage%</span>
        <input type='number' value={slippage} onChange={(e) => handleSetSlippage(e)} />
      </div>
      

      <button onClick={handleSwap}>swap</button>

      <Txs />
    </div>
  )
}

export default Swap