import React, { useState } from 'react'
import { displayPubKey, removeDots, udToDecimal } from '../constants'
import useAmmStore from '../store/ammStore'
import { IoCheckmarkSharp, IoClose, IoArrowForward } from 'react-icons/io5'
import './styles/Txs.scss'

const Txs = () => {
  const { txs, tokens }  = useAmmStore()
  // don't reload in case of tokens changeing? 
  // const txs = useAmmStore(state => state.txs)

  const getTokenSymbol = (s: string) => {
    return tokens[s]?.symbol
  }

  return (
    <div>
      <h2>transactions</h2>
      <div className='transaction-table'>
        <table>
          <thead>
            <tr>
              <th>Status</th>
              <th>Input</th>
              <th></th>
              <th>Output</th>
            </tr>
          </thead>
          <tbody>
            {txs &&
              txs
                .slice(0)
                .reverse()
                .map((tx, i) => (
                  <tr key={i}>
                    <td>
                      {tx.status === "confirmed" ? (
                        <a
                          target="_blank"
                          href={`/apps/ziggurat/indexer/${tx.hash}`}
                        >
                          <IoCheckmarkSharp color="green" />{" "}
                          {displayPubKey(tx.hash)}
                        </a>
                      ) : (
                        <a
                          target="_blank"
                          href={`/apps/ziggurat/indexer/${tx.hash}`}
                        >
                          <IoClose color="red" />
                          {displayPubKey(tx.hash)}
                        </a>
                      )}
                    </td>
                    <td>
                      {udToDecimal(tx.input.amount).toFixed(2)}{" "}
                      {getTokenSymbol(tx.input.meta)}
                    </td>
                    <td>
                      <IoArrowForward />
                    </td>
                    <td>
                      {udToDecimal(tx.output.amount).toFixed(2)}{" "}
                      {getTokenSymbol(tx.output.meta)}
                    </td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default Txs