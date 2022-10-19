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
  poolValue: PoolValue[]
  init: () => Promise<void>;
  getPoolPoke: () => Promise<void>;
  templateScry: () => void;
  testPoke: () => void;
}

const useStore = create<Store>((set, get) => ({
  templateValues: [],
  poolValue: [],
  init: async () => {
    // Update the subscriptions and scries to match your app's routes
    api.subscribe(createSubscription('amm', '/pools', handlePoolsUpdate(get, set)));

    // get().templateScry();
  },
  getPoolPoke: async () => {
    await api.poke({app: 'amm', mark: 'amm-action', json: { 'get-pool': null }})
  },
  templateScry: async () => {
    const templateValues = await api.scry<TestValue[]>({ app: 'amm', path: '/testpath' });
    set({ templateValues });
  },
  testPoke: async () => {
    await api.poke({
      app: 'amm',
      mark: 'amm-action',
      // json: { 'fe-test': {'squid': 69420} }
      json: {'fe-test': 69420}
    });
  },
}))

export default useStore
