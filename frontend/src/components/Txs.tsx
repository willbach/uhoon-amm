import React, { useState } from 'react'
import useAmmStore from '../store/ammStore'

const Txs = () => {
  const { txs } = useAmmStore()


  return (
    <div>
      <h1>Txs</h1>
      <div>
        {txs?.map((tx, i) => (
          <div key={i}>
            <span>input: {tx.input.amount} </span>
            <span>hash: {tx.hash}</span>
            <span>output: {tx.output.amount}</span>
          </div>
        ))}
      </div>
    </div>
  )
}

export default Txs