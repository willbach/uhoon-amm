// Pools.tsx
import { useWalletStore } from '@uqbar/wallet-ui';
import Decimal from 'decimal.js';
import React, { useState } from 'react';
import { removeDots, TEN_18, addDecimalDots } from '../constants';
import useAmmStore from '../store/ammStore';
import './styles/Pools.scss';

const Pools = () => {
  const { pools, addLiq, removeLiq } = useAmmStore();
  const setInsetView = useWalletStore(state => state.setInsetView)
  const [selectedPool, setSelectedPool] = useState<string | null>(null);
  
  const [addAmount1, setAddAmount1] = useState<string>('');
  const [addAmount2, setAddAmount2] = useState<string>('');
  //  for now no automatic token-2 pricing
  const [removeAmount, setRemoveAmount] = useState<string>('');
  
  const toggleDropdown = (poolKey: string) => {
    setSelectedPool(poolKey === selectedPool ? null : poolKey);
    // handle set other values to 0
  };
  

  const handleAddLiquidity = () => {
    if (!selectedPool)  return
    const pool = pools[selectedPool];

    const token1 = {
      meta: pool['token-a'].metadata,
      amount: addDecimalDots(new Decimal(addAmount1).mul(TEN_18).toString()),
    }

    const token2 = {
      meta: pool['token-b'].metadata,
      amount: addDecimalDots(new Decimal(addAmount2).mul(TEN_18).toString()),
    }

    addLiq(pool.address, token1, token2)
    setInsetView('confirm-most-recent')
  }

  const handleRemoveLiquidity = () => {
    if (!selectedPool)  return
    const pool = pools[selectedPool];

    // check decimals on LIQ TOKEN
    const amount = addDecimalDots(new Decimal(removeAmount).mul(TEN_18).toString()) 

    removeLiq(pool.address, amount)
        setInsetView('confirm-most-recent')
  }


  return (
    <div className='pools-container'>
      <table className='pools-table'>
        <thead>
          <tr>
            <th>Pool</th>
            <th>Total Token-A</th>
            <th>Total Token-B</th>
            <th>Your Shares</th>
          </tr>
        </thead>
        <tbody>
          {pools &&
            Object.entries(pools).map(([poolstring, pool], i) => {
              const tokenA = new Decimal(
                removeDots(pool['token-a']['pool-account'].balance || '0')
              ).div(TEN_18);
              const tokenB = new Decimal(
                removeDots(pool['token-b']['pool-account'].balance || '0')
              ).div(TEN_18);

              return (
                <>
                  <tr key={'pool-' + i} onClick={() => toggleDropdown(poolstring)}>
                    <td>
                      <a
                        target="_blank"
                        href={`/apps/ziggurat/indexer/item/${pool.address}`}
                      >
                        {pool.name}
                      </a>
                    </td>
                    <td>
                      {tokenA.toFixed(2)} {pool['token-a'].name}
                    </td>
                    <td>
                      {tokenB.toFixed(2)} {pool['token-b'].name}
                    </td>
                    <td>
                      Your shares:{' '}
                      {new Decimal(
                        removeDots(pool['our-liq-token-account'].balance || '0')
                      )
                        .div(TEN_18)
                        .toFixed(2)}
                    </td>
                  </tr>
                  {selectedPool === poolstring && (
                    <tr className="liquidity-dropdown">
                      <td colSpan={4}>
                        <div className="row-dropdown">
                          <div className="row-dropdown-content">
                            <div className="input-group add-liquidity">
                              <label>Add Liquidity</label>
                              <input onChange={(e) => setAddAmount1(e.target.value)} type="number" placeholder="Token A Amount" />
                              <input onChange={(e) => setAddAmount2(e.target.value)} type="number" placeholder="Token B Amount" />
                              <button onClick={handleAddLiquidity} className="submit-button">Add Liquidity</button>
                            </div>
                            <div className="input-group remove-liquidity">
                              <label>Remove Liquidity</label>
                              <input
                                onChange={(e) => setRemoveAmount(e.target.value)} 
                                type="number"
                                placeholder="Liquidity Tokens Amount"
                              />
                              <button onClick={handleRemoveLiquidity} className="submit-button">Remove Liquidity</button>
                            </div>
                          </div>
                        </div>
                      </td>
                    </tr>
                  )}
                </>
              );
            })}
        </tbody>
      </table>
    </div>
  );
};

export default Pools;
