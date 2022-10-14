import { GetState, SetState } from "zustand";
import { TestValue } from "../types/TestValue";
import { Store } from "./store";

export const handleTemplateUpdate = (get: GetState<Store>, set: SetState<Store>) => (newValue: TestValue) => {
  const { templateValues } = get();
  console.log(newValue);
  set({ templateValues: templateValues.concat([newValue]) });
}
