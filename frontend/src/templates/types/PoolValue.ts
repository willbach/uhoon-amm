export interface PoolValue {
    id: Pool
}

interface Pool {
    'liq-shares': string
    name: string
    'our-liq-token-account': string
    'token-a': Token
    'token-b': Token
}

interface Token {
    'current-price': number
    liquidity: string
    metadata: string
    name: string
    'our-account': string
    'pool-account': string
    symbol: string
}