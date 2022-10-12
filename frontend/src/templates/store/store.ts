import { SubscriptionRequestInterface } from "@urbit/http-api"
import create from "zustand"
import api from "../api"
import { TemplateValue } from "../types/TemplateValue"
import { handleTemplateUpdate } from "./subscriptions"

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
  templateValues: TemplateValue[];
  init: () => Promise<void>;
  templateScry: () => void;
  testPoke: () => void;
}

const useStore = create<Store>((set, get) => ({
  templateValues: [],
  init: async () => {
    // Update the subscriptions and scries to match your app's routes
    api.subscribe(createSubscription('amm', '/test', handleTemplateUpdate(get, set)));

    // get().templateScry();
  },
  templateScry: async () => {
    const templateValues = await api.scry<TemplateValue[]>({ app: 'amm', path: '/template' });
    set({ templateValues });
  },
  testPoke: async () => {
    await api.poke({
      app: 'amm',
      mark: 'amm-action',
      json: { 'fe-test': {'squid': 69420} }
    });
  },
}))

export default useStore
