import create from "zustand"
import api from '../api'
import { handlePoolsUpdate, createSubscription } from "./subscriptions"

export interface Store {
  pools: PoolMap
  tokens: TokenMap
  txs: Tx[]
  init: () => Promise<void>;
  setTokens: () => Promise<void>;
  getPoolPoke: () => Promise<void>;
  swap: (jon: any) => Promise<void>;
}

// all types in urbit type strings to begin, e.g "100.100.203" or "0x.dead.beef", more for reference than making everything typesafe

export interface PoolMap {
  [key: string]: Pool     // "token-a/token-b": Pool
}
export interface Pool {
  "address": string
  "liq-shares": string
  "liq-token-meta": string
  "name": string
  "our-liq-token-account": TokenAccount
  "token-a": TokenData
  "token-b": TokenData
}

export interface TokenData {
  "name": string  // "tokena|tokenb Pool"
  "metadata": string 
  "liquidity": string
  "current-price": string
  "symbol": string
  "our-account": TokenAccount
  "pool-account": TokenAccount
}

export interface TokenMap {
  [key: string]: TokenData    // meta => TokenData
}
export interface TokenAccount {
  id: string // our token-account id
  allowances: BalanceMap
  balance: string
  metadata: string // TODO, check the differences with ZIGS and other fungible tokens here
  nonces: BalanceMap
}

export interface BalanceMap {
  [key: string]: string
}

export interface TokenAmount {
  meta: string
  amount: string
}
export interface Tx {
  input: TokenAmount
  hash: string
  status: string
  output: TokenAmount
}



const useAmmStore = create<Store>((set, get) => ({
  pools: {},
  txs: [],
  init: async () => {
    // Update the subscriptions and scries to match your app's routes
    await api.subscribe(createSubscription('amm', '/updates', handlePoolsUpdate(get, set)));
    
  },
  getPoolPoke: async () => {
    await api.poke({app: 'amm', mark: 'amm-action', json: { 'get-pool': null }})
  },
  tokens: {},
  setTokens: async () => {
    // figure out how to set "tokens" in straight subscriptions instead
    const { pools } = get()
    let tm: TokenMap = {};
    
    for (let pool of Object.values(pools)) {
      const meta1 = pool["token-a"]["metadata"]
      const meta2 = pool["token-b"]["metadata"]

      tm[meta1] = pool["token-a"]
      tm[meta2] = pool["token-b"] // do double updates matter in this case?
    }

    console.log('tokens: ', tm)


    set({ tokens: tm })
  },
  swap: async (jon: any) => {
    const res = await api.poke({ app: 'amm', mark: 'amm-action', json: jon })
    console.log('swap response: ', res)
  }
}))

export default useAmmStore
