import { SubscriptionRequestInterface } from "@urbit/http-api"
import create from "zustand"
import api from "../api"
import { TestValue } from "../types/TestValue"
import { PoolValue } from "../types/PoolValue"
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
  templateValues: TestValue[];
  rawPools: PoolValue[]
  init: () => Promise<void>;
  getPoolPoke: () => Promise<void>;
  templateScry: () => void;
  initState: () => void;
}

const useStore = create<Store>((set, get) => ({
  templateValues: [],
  rawPools: [],
  init: async () => {
    // Update the subscriptions and scries to match your app's routes
    await api.subscribe(createSubscription('amm', '/pools', handlePoolsUpdate(get, set)));
    
    await api.poke({
      app: 'amm',
      mark: 'amm-action',
      // json: { 'fe-test': {'squid': 69420} }
      json: {'fe-test': 69420}
    });
    // get().templateScry();
  },
  getPoolPoke: async () => {
    await api.poke({app: 'amm', mark: 'amm-action', json: { 'get-pool': null }})
  },
  templateScry: async () => {
    const templateValues = await api.scry<TestValue[]>({ app: 'amm', path: '/testpath' });
    set({ templateValues });
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

export default useStore
