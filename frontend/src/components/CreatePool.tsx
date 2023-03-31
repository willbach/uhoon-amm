import { useWalletStore } from '@uqbar/wallet-ui';
import Decimal from 'decimal.js';
import React, { useMemo, useState } from 'react';
import { addDecimalDots, TEN_18 } from '../constants';
import useAmmStore from '../store/ammStore';
import './styles/CreatePool.scss';

const CreatePool = () => {
  const [token1, setToken1] = useState({ address: '', amount: '' });
  const [token2, setToken2] = useState({ address: '', amount: '' });

  const { assets, metadata, setInsetView } = useWalletStore()

  const { account, startPool } = useAmmStore()


  const tokensList = useMemo(() => {
    if (!account) return [];

    const listTokens = Object.entries(assets[account])
      .filter(([, value]) => value.token_type === 'token')
      .map(([key, value]) => {
        return { meta: value.data?.metadata, balance: value.data?.balance };
      });

    return listTokens;
  }, [account, assets]);

  const handleTokenChange = (e: any, tokenIndex: number) => {
    const newToken = {
      ...tokenIndex === 1 ? token1 : token2,
      address: e.target.value,
    };
    if (tokenIndex === 1) {
      setToken1(newToken);
    } else {
      setToken2(newToken);
    }
  };

  const handleAmountChange = (e: any, tokenIndex: number) => {
    const newToken = {
      ...tokenIndex === 1 ? token1 : token2,
      amount: e.target.value,
    };
    if (tokenIndex === 1) {
      setToken1(newToken);
    } else {
      setToken2(newToken);
    }
  };

  const createPool = () => {
    const a1 = addDecimalDots(new Decimal(token1?.amount || '0').mul(TEN_18).toString())
    const a2 = addDecimalDots(new Decimal(token2?.amount || '0').mul(TEN_18).toString())

    const jon = { 
      "start-pool": {
        "token-a": {
          meta: token1.address,
          amount: a1,
        },
        "token-b": {
          meta: token2.address,
          amount: a2,
        }
      }
    }

    console.log('start-pool json: ', jon)
    startPool(jon)
    setInsetView('confirm-most-recent')
  }

  // The rest of the component JSX will be placed here
  return (
    <div className="create-pool">
      <h1>Create Pool</h1>
      <div className="input-group">
        <label>Token 1:</label>
        <select value={token1.address} onChange={(e) => handleTokenChange(e, 1)}>
          <option value="" key="first-option1"></option>
          {tokensList.map((t, i) => (
            <option value={t.meta} key={'option1-' + i}>
              {metadata[t.meta]?.data?.name}
            </option>
          ))}
        </select>
        <label>Amount:</label>
        <input type="text" value={token1.amount} onChange={(e) => handleAmountChange(e, 1)} />
      </div>
      <div className="input-group">
        <label>Token 2:</label>
        <select value={token2.address} onChange={(e) => handleTokenChange(e, 2)}>
          <option value="" key="first-option2"></option>
          {tokensList.map((t, i) => (
            <option value={t.meta} key={'option2-' + i}>
              {metadata[t.meta]?.data?.name}
            </option>
          ))}
        </select>
        <label>Amount:</label>
        <input type="text" value={token2.amount} onChange={(e) => handleAmountChange(e, 2)} />
      </div>
      <button onClick={createPool}>Create Pool</button>
    </div>
  );
};

export default CreatePool;