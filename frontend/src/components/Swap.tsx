import { useWalletStore, AccountSelector } from '@uqbar/wallet-ui'
import Decimal from 'decimal.js'
import React, { useCallback, useEffect, useMemo, useState } from 'react'
import { IoSwapVertical } from 'react-icons/io5'
import { addDecimalDots, removeDots, splitString, TEN_18, AMM_ADDRESS } from '../constants'
import useAmmStore, { Pool, TokenData } from '../store/ammStore'
import Txs from './Txs'
import './styles/Swap.scss';


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


  const updateCurrentPrice = useCallback(() => {
    const pool = getPool();
    if (!pool) {
      setCurrentPrice('No pool exists for selected tokens');
      return;
    }
    const t2 = token2 === pool['token-b']?.metadata ? pool['token-b'] : pool['token-a'];
    const price2 = new Decimal(removeDots(t2['current-price']));
    const currPrice = price2.div(TEN_18).abs().toFixed(9);
    setCurrentPrice(currPrice);
  }, [token1, token2, pools, tokens]);


  const handleAmountChange = useCallback(
    (e, type) => {
      // if (e === null) calculateAmounts(new Decimal(amount1 || '0'), token1, token2, slippage, false, amount1);

      let inputValue = e ? e.target.value : '';
  
      if (type === 'amount1') {
        if (inputValue === '') {
          setAmount1('');
          setAmount2('');
          return;
        }
  
        const amountA = new Decimal(inputValue);
        calculateAmounts(amountA, token1, token2, slippage, false, inputValue);
      } else if (type === 'amount2') {
        if (inputValue === '') {
          setAmount1('');
          setAmount2('');
          return;
        }
  
        const amountB = new Decimal(inputValue);
        calculateAmounts(amountB, token2, token1, slippage, true, inputValue);
      }
    },
    [token1, token2, slippage]
  );

  const calculateAmounts = (
    amount: Decimal,
    tokenA: string,
    tokenB: string,
    slippage: string,
    reverse = false,
    rawInput: string
  ) => {
    const pool = getPool();
    const t1 = tokenA === pool["token-a"]?.metadata ? pool["token-a"] : pool["token-b"];
    const t2 = tokenB === pool["token-b"]?.metadata ? pool["token-b"] : pool["token-a"];

    const price1 = new Decimal(removeDots(t1["current-price"]));
    const price2 = new Decimal(removeDots(t2["current-price"]));

    const slippageMultiplier = new Decimal(100).minus(slippage).div(100);

    const noslippageamount2 = reverse ? price1.mul(amount).div(TEN_18) : price2.mul(amount).div(TEN_18);


    const liqA = new Decimal(removeDots(t1.liquidity)).div(TEN_18);
    const liqB = new Decimal(removeDots(t2.liquidity)).div(TEN_18);

    const k = liqA.mul(liqB);

    let amountA, amountB;
    if (reverse) {
      amountB = amount;
      amountA = k.div(liqB.plus(amount)).minus(liqA);
      setAmount1(amountA.abs().toFixed(3));
      setAmount2(rawInput);
    } else {
      amountA = amount;
      amountB = k.div(liqA.plus(amount)).minus(liqB);
      setAmount2(amountB.abs().toFixed(3));
      setAmount1(rawInput);
    }
  
    
    const initialPrice = liqA.div(liqB);
    const finalPrice = reverse ? liqA.plus(amountA).div(liqB.minus(amountB)) : liqA.minus(amountA).div(liqB.plus(amountB));
    const priceIm = finalPrice.div(initialPrice).minus(1).abs().mul(100);
  
    const minreceived = amountB.mul(slippageMultiplier).abs();
  
    const currPrice = liqA.div(liqB).abs().toFixed(9);
    setCurrentPrice(currPrice);
  
    setMinimumReceived(minreceived.toFixed(3));
    setPriceImpact(priceIm.toFixed(2));
  };

  const handleSetSlippage = (e: React.ChangeEvent<HTMLInputElement>) => {
    let inputValue = e.target.value;
  
    // Check if inputValue is empty or has a trailing dot or trailing zero
    if (inputValue === '' || inputValue.match(/^\d+\.$/) || inputValue.match(/^0\d+$/)) {
      // Set the state without modifying inputValue
      setSlippage(inputValue);
      return;
    }
  
    // Check if inputValue is a valid number
    if (!isNaN(Number(inputValue))) {
      setSlippage(inputValue);
    }
    //  todo: make changing slippage not null other fields... smh
  };


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

  }


  const handleSwap = async () => {
    // console.log('am1, uam1, am2, uam2, minimumR', amount1, amount2, minimumReceived)

    const payment = addDecimalDots((new Decimal(amount1).mul(TEN_18)).toFixed(0))
    const receive = addDecimalDots((new Decimal(minimumReceived).mul(TEN_18)).toFixed(0))


    const pool = getPool()

    // TODO: router contract between pools. 

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
    handleAmountChange(undefined, 'amount1');
  }, [handleAmountChange]);

  // Update the current price when token1 or token2 changes
  useEffect(() => {
    updateCurrentPrice();
  }, [token1, token2, updateCurrentPrice]);

  return (
    <div className="swap-container">
      <div className="swap-card">
        <span className="text-white">
          current price: 1 {tokens[token1]?.name} = {currentPrice} {tokens[token2]?.name}</span>

        <div className='input-group'>
          <div className='select-container'>
            <select className='custom-select' value={token1} onChange={(e) => setToken1(e.target.value)}>
              <option value={'token1'} key='first-option1'></option>
              {tokens && Object.values(tokens).map((t, i) => <option className='option' value={t.metadata} key={'option1-' + i}>{t.name} {(new Decimal(removeDots(t['our-account'].balance || '0')).div(TEN_18)).toFixed(2)} </option>)}

            </select>
          </div>

          <input className='input-field' type='text' placeholder='amount' value={amount1} onChange={(e) => handleAmountChange(e, 'amount1')} />
        </div>

        <button onClick={handleSwitchDir}>
          <IoSwapVertical />
        </button>

        <div className='input-group'>
          <select className='custom-select' value={token2} onChange={(e) => setToken2(e.target.value)}>
            <option value={'token2'}></option>
            {tokens && Object.values(tokens).map((t, i) => <option value={t.metadata} key={'option2-' + i}>{t.name} {(new Decimal(removeDots(t['our-account'].balance || '0')).div(TEN_18)).toFixed(2)}</option>)}
          </select>

          <input className='input-field' type='text' placeholder='amount' value={amount2} onChange={(e) => handleAmountChange(e, 'amount2')} />
        </div>

        <div className='metrics-container'>
          <div className='metric'>
            <span>price-impact: {priceImpact}%</span>
          </div>

          <div className='metric'>
            <span>minimum received: {minimumReceived}</span>
          </div>

          <div className='metric'>
            <span>slippage%</span>
            <input type='number' value={slippage} onChange={(e) => handleSetSlippage(e)} />
          </div>
        </div>

        <button className='swap-button' onClick={handleSwap}>swap</button>
      </div>
      <Txs />
    </div>
  )
}

export default Swap