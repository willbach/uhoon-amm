import { SubscriptionRequestInterface } from "@urbit/http-api"
import create from "zustand"
import api from '../api'
import { handlePoolsUpdate } from "./subscriptions"

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

export interface Store {
  templateValues: any[];
  rawPools: any[]
  init: () => Promise<void>;
  getPoolPoke: () => Promise<void>;
  initState: () => void;
}

const useAmmStore = create<Store>((set, get) => ({
  templateValues: [],
  rawPools: [],
  init: async () => {
    // Update the subscriptions and scries to match your app's routes
    await api.subscribe(createSubscription('amm', '/updates', handlePoolsUpdate(get, set)));
    
    // get().templateScry();
  },
  getPoolPoke: async () => {
    await api.poke({app: 'amm', mark: 'amm-action', json: { 'get-pool': null }})
  },
  initState: async () => {
    await api.poke({
      app: 'amm',
      mark: 'amm-action',
      // json: { 'fe-test': {'squid': 69420} }
      json: {'fe-test': 69420}
    });
  },
}))

export default useAmmStore
