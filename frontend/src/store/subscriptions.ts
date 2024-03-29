import { GetState, SetState } from "zustand";
import { SubscriptionRequestInterface } from "@urbit/http-api"
import ammStore, { PoolMap, Tx, Store } from "./ammStore";

export interface AmmUpdate {
  pools?: PoolMap
  txs?: Tx[]
  account?: string
}

export const handlePoolsUpdate = (get: GetState<Store>, set: SetState<Store>) => async (update: any) => {
  
  console.log('AMM UPDATE: ', update)


  if ('txs' in update) {
    const txs = update["txs"]
    set({ txs })
  }

  if ('pools' in update) {
    const pools = update["pools"]

    set({ pools })
    const { setTokens } = get()
    setTokens()
    set({ syncing: false })
  }

  if ('account' in update) {
    const account = update["account"]
    set({ account })
  }
}

export function createSubscription(app: string, path: string, e: (data: any) => void): SubscriptionRequestInterface {
  const request = {
    app,
    path,
    event: e,
    err: () => console.warn('SUBSCRIPTION ERROR'),
    quit: () => {
      throw new Error('subscription clogged')
    }
  }
  // TODO: err, quit handling (resubscribe?)
  return request
}