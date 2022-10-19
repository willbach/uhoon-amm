import { calculateNewValue } from "@testing-library/user-event/dist/utils";
import { GetState, SetState } from "zustand";
import { TestValue } from "../types/TestValue";
import { PoolValue } from "../types/PoolValue";
import { Store } from "./store";

export const handleTemplateUpdate = (get: GetState<Store>, set: SetState<Store>) => (newValue: TestValue) => {
  const { templateValues } = get();
  console.log(newValue);
  set({ templateValues: templateValues.concat([newValue]) });
}

export const handlePoolsUpdate = (get: GetState<Store>, set: SetState<Store>) => (newValue: PoolValue) => {
  const{ poolValue } = get();
  // console.log("Got a pool: ");
  // console.log(newValue);
  set({ poolValue: poolValue.concat([newValue]) });
}