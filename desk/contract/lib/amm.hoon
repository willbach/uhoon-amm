::  /+  *zig-sys-smart
|%
::  values
++  trading-fee   30
++  lp-fee        25
++  protocol-fee  5
++  our-fungible-contract
  0x1243.45f7.fca9.a019.1c65.1316.bffa.10d6.cdb8.42e6.06fe.0f79.a3ee.e5a2.ca63.3327
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