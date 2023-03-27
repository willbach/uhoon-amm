import React, { useState } from 'react'
import { displayPubKey, removeDots, udToDecimal } from '../constants'
import useAmmStore from '../store/ammStore'
import { IoCheckmarkSharp, IoClose } from 'react-icons/io5'

const Txs = () => {
  const txs  = useAmmStore(state => state.txs)
  const tokens = useAmmStore(state => state.tokens)
  // don't reload in case of tokens changeing? 

  const getTokenName = (s: string) => {
    return tokens[s]?.name
  }

  return (
    <div>
      <h1>Txs</h1>
      <div>
        {txs && txs.slice(0).reverse().map((tx, i) => (
          <div key={i}>
            
            <span>{(tx.status === 'confirmed') ? <a target='_blank' href={`/apps/ziggurat/indexer/${tx.hash}`}><IoCheckmarkSharp color='green'/> {displayPubKey(tx.hash)}</a> :<a target='_blank' href={`/apps/ziggurat/indexer/${tx.hash}`}><IoClose color='red'/>{displayPubKey(tx.hash)}</a>}</span>
            <span>{udToDecimal(tx.input.amount).toFixed(2)} {getTokenName(tx.input.meta)} {'==>'} </span>
            <span>{udToDecimal(tx.output.amount).toFixed(2)} {getTokenName(tx.output.meta)}</span>
          </div>
        ))}
      </div>
    </div>
  )
}

export default Txs