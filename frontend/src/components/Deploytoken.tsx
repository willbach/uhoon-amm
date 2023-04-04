import { useWalletStore } from '@uqbar/wallet-ui';
import Decimal from 'decimal.js';
import React, { useState } from 'react';
import { addDecimalDots, TEN_18 } from '../constants';
import useAmmStore from '../store/ammStore';
import './styles/DeployToken.scss';

const DeployToken = () => {
  const [name, setName] = useState('');
  const [symbol, setSymbol] = useState('');
  const [cap, setCap] = useState('');
  const [minters, setMinters] = useState<string[]>([]);
  const [initialDistribution, setInitialDistribution] = useState<{address: string, amount: string}[]>([]);

  const deploy = useAmmStore(state => state.deploy)
  const setInsetView = useWalletStore(state => state.setInsetView)

  const handleMintersChange = (e: any, index: number) => {
    const newMinters = [...minters];
    newMinters[index] = e.target.value;
    setMinters(newMinters);
  };

  const handleInitialDistributionAddress = (e: any, index: number) => {
    const newInitialDistribution = [...initialDistribution];
    newInitialDistribution[index] = {
      ...newInitialDistribution[index],
      address: e.target.value,
    };
    setInitialDistribution(newInitialDistribution);
  };

  const handleInitialDistributionAmount = (e: any, index: number) => {
    const newInitialDistribution = [...initialDistribution];
    newInitialDistribution[index] = {
      ...newInitialDistribution[index],
      amount: e.target.value,
    };
    setInitialDistribution(newInitialDistribution);
  };

  const handleDeploy = () => {
    const initDist = initialDistribution ? initialDistribution.map(dist => {
      return {
        to: dist.address,
        amount: addDecimalDots(new Decimal(dist.amount || '0').mul(TEN_18).toFixed(0)),
      }
    }) : []


    const nocap = cap ? addDecimalDots((new Decimal(cap || '0').mul(TEN_18)).toFixed(0)) : null

    console.log('cap & nocap: ', cap, nocap)

    const jon = {
      "deploy-token": {
        name: name,
        symbol: symbol,
        cap: nocap,
        minters: minters,
        "initial-distribution": initDist
      }
    }
    console.log('deploy json', jon)
    deploy(jon)
    setInsetView('confirm-most-recent')
  }

  // The rest of the component JSX will be placed here
  return (
    <div className="deploy-token">
      <h1>Deploy New Token</h1>
      <div className="input-group">
        <label>Name:</label>
        <input type="text" value={name} onChange={(e) => setName(e.target.value)} />
      </div>
      <div className="input-group">
        <label>Symbol:</label>
        <input type="text" value={symbol} onChange={(e) => setSymbol(e.target.value)} />
      </div>
      <div className="input-group">
        <label>Cap:</label>
        <input type="text" value={cap} onChange={(e) => setCap(e.target.value)} />
      </div>
      <h2>Minters:</h2>
      {minters.map((minter, index) => (
        <div key={index} className="input-group">
          <label>Minter {index + 1}:</label>
          <input type="text" value={minter} onChange={(e) => handleMintersChange(e, index)} />
        </div>
      ))}
      <button onClick={() => setMinters([...minters, ''])}>Add Minter</button>
      <h2>Initial Distribution:</h2>
      {initialDistribution.map((dist, index) => (
        <div key={index} className="input-group distribution">
          <label>Address {index + 1}:</label>
          <input
            type="text"
            value={dist.address}
            onChange={(e) => handleInitialDistributionAddress(e, index)}
          />
          <label>Amount:</label>
          <input
            type="text"
            value={dist.amount}
            onChange={(e) => handleInitialDistributionAmount(e, index)}
          />
        </div>
      ))}
      <button
        onClick={() =>
          setInitialDistribution([...initialDistribution, { address: '', amount: '' }])
        }
      >
        Add Distribution
      </button>
      <div className="deploy-button">
        <button onClick={handleDeploy}>Deploy Token</button>
      </div>
    </div>
  )

};

export default DeployToken;