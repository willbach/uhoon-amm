import Decimal from 'decimal.js'
import React, { useEffect } from 'react'
import { removeDots, splitString, TEN_18 } from '../constants'
import useAmmStore from '../store/ammStore'

const Pools = () => {
  const { pools } = useAmmStore()

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
            <td>{(new Decimal(removeDots(pool['token-a']['pool-account'].balance)).div(TEN_18)).toFixed(2)} {pool['token-a'].name}</td>
            <td>{(new Decimal(removeDots(pool['token-b']['pool-account'].balance)).div(TEN_18)).toFixed(2)} {pool['token-b'].name}</td>
            <td>your shares: {(new Decimal(removeDots(pool['our-liq-token-account'].balance)).div(TEN_18)).toFixed(2)}</td>
          </tr>
           )
        })}
      </table>

    </>
  )
}

export default Pools