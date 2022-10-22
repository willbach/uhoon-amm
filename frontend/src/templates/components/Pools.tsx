import { keyboard } from '@testing-library/user-event/dist/keyboard'
import React from 'react'
import { PoolValue } from "../types/PoolValue"

interface PoolProps extends React.HTMLAttributes<HTMLDivElement> {
    pools: PoolValue[]
}

const Pools: React.FC<PoolProps> = (props) => {
    const pools = props.pools

    console.log(pools)
    
    return (
        <div {...props} className={`pool ${props.className || ``}`}>
            {pools.map(pool => {
                let liqID:string = ''

                Object.keys(pools).forEach((num) => {
                    Object.keys(pools[num as unknown as number]).forEach((key) => {
                        liqID = key
                    })
                })
                return(
                    <p>
                        <b>{pool[liqID as keyof typeof pool].name}</b><br/>
                    <b>{pool[liqID as keyof typeof pool]['token-a'].name}: </b>
                        {pool[liqID as keyof typeof pool]['token-a'].liquidity}<br/>
                    <b>{pool[liqID as keyof typeof pool]['token-b'].name}: </b>
                        {pool[liqID as keyof typeof pool]['token-b'].liquidity}
                    </p>
                )
            })}
        </div>
    )
}

export default Pools