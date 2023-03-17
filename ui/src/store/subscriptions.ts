import { GetState, SetState } from "zustand";
import ammStore, { Store }  from "./ammStore";

export const handleTemplateUpdate = (get: GetState<Store>, set: SetState<Store>) => (newValue: any) => {
  const { templateValues } = get();
  console.log(newValue);
  set({ templateValues: templateValues.concat([newValue]) });
}

export const handlePoolsUpdate = (get: GetState<Store>, set: SetState<Store>) => (newValue: any) => {
  const{ rawPools } = get();
  // console.log("Got a pool: ");
  // console.log(newValue);

  console.log('AMM UPDATE: ', newValue)

  set({ rawPools: rawPools.concat([newValue]) });
}