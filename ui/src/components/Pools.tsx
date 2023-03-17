import React, { useEffect } from 'react'
import { removeDots, splitString, TEN_18 } from '../constants'
import useAmmStore from '../store/ammStore'

const Pools = () => {
  const { pools } = useAmmStore()

  // maybe add a /token path to display balances etc. 
  return (
    <>
      <table>
        <tr>
          <th>Pool</th>
          <th>total token-a</th>
          <th>total token-b</th>
          <th>your shares</th>
        </tr>
        {pools && Object.entries(pools).map(([poolstring, pool], i) => {
          return (
          <tr>
            <td><a target='_blank' href={`/apps/ziggurat/indexer/item/${pool.address}`}>{pool.name}</a></td>
            <td>{(BigInt(removeDots(pool['token-a']['pool-account'].balance)) / TEN_18).toString()} {pool['token-a'].name}</td>
            <td>{(BigInt(removeDots(pool['token-b']['pool-account'].balance)) / TEN_18).toString()} {pool['token-b'].name}</td>
            <td>your shares: {(BigInt(removeDots(pool['our-liq-token-account'].balance)) / TEN_18).toString()}</td>
          </tr>
           )
        })}
      </table>

    </>
  )
}

export default Pools