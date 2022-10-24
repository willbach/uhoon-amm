/+  *zig-sys-smart
|%
::  values
++  trading-fee   30
++  lp-fee        25
++  protocol-fee  5
++  our-fungible-contract
  0x5856.b89a.1915.b17a.7bab.9be2.5bc7.7c47.1c9b.ffdf.79f6.5d13.8893.7ca3.137a.7d3e
++  dec-18  1.000.000.000.000.000.000
::  data types
+$  pool
  $:  token-a=[meta=id contract=id liq=@ud]
      token-b=[meta=id contract=id liq=@ud]
      liq-shares=@ud
      liq-token-meta=id
  ==
::
+$  token-args
  $:  meta=id
      amount=@ud
      pool-account=(unit id)
      caller-account=(unit id)
  ==
::
::  actions
::
+$  action
  $%  $:  %start-pool
          token-a=token-args
          token-b=token-args
      ==
  ::
      $:  %add-liq
          pool-id=id
          liq-shares-account=(unit id)
          token-a=token-args
          token-b=token-args
      ==
  ::
      $:  %remove-liq
          pool-id=id
          liq-shares-account=id
          amount=@ud
          token-a=token-args
          token-b=token-args
      ==
  ::
      $:  %swap
          pool-id=id
          payment=token-args
          receive=token-args
      ==
  ==
::
::  helpers
::
++  get-pool-salt
  |=  [meta-a=id meta-b=id]
  ^-  @
  ?:  (gth meta-a meta-b)
    (cat 3 meta-a meta-b)
  (cat 3 meta-b meta-a)
--