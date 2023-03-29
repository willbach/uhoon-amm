import create from "zustand"
import api from '../api'
import { handlePoolsUpdate, createSubscription } from "./subscriptions"

export interface Store {
  pools: PoolMap
  tokens: TokenMap
  txs: Tx[]
  account: string | null;
  init: () => Promise<void>;
  setTokens: () => Promise<void>;
  getPoolPoke: () => Promise<void>;
  swap: (jon: any) => Promise<void>;
  allow: (jon: any) => Promise<void>;
  
  addLiq: (pool: string, token1: TokenAmount, token2: TokenAmount) => Promise<void>;
  removeLiq: (pool: string, amount: string) => Promise<void>;

  checkCurrentAccount: (address: string) => Promise<void>;
  setCurrentAccount: (account: string) => Promise<void>;
  connect: () => Promise<void>;

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
  account: null,
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
  },
  allow: async (jon: any) => {
    const res = await api.poke({ app: 'amm', mark: 'amm-action', json: jon })
  },

  addLiq: async (pool: string, token1: TokenAmount, token2: TokenAmount) => {
    // new format bby, better probably to structure json in here?
    const jon = {
      "add-liq": {
        "pool-id": pool,
        "token-a": token1,
        "token-b": token2,
      }
    }
    console.log('addLiq poke json: ', jon)
    const res = await api.poke({ app: 'amm', mark: 'amm-action', json: jon })
    console.log('add-liq poke: ', res)
  },

  removeLiq: async (pool: string, amount: string) => {
    const jon = {
      "remove-liq": {
        "pool-id": pool,
        "amount": amount,
      }
    }
    console.log('remove liq json: ', jon)
    const res = await api.poke({ app: 'amm', mark: 'amm-action', json: jon })
    console.log('remove-liq poke: ', res)
  },

  checkCurrentAccount: async (address: string) => {
    // checks if our-account in gall state is the same as selected account in wallet :)
    
    const { account, setCurrentAccount } = get()
    if (account !== address) {
      setCurrentAccount(address)
    }
  },

  setCurrentAccount: async (account: string) => {
    // account in hex format
    const jon = {
      "set-our-address": {
        address: account
      }
    }

    console.log('setaccount: ', account)
    const res = await api.poke({ app: 'amm', mark: 'amm-action', json: jon })
    console.log('set account poke: ', res)
  },

  connect: async () => {
    const jon = {
      connect: null
    }

    const res = await api.poke({ app: 'amm', mark: 'amm-action', json: jon })
    console.log('connect poke: ', res)
  }

  }))

export default useAmmStore
