/+  *zig-sys-smart
|%
::  fee values (in basis points)
::  0.3% fee charged on swaps
::  of the 0.3% fee, protocol takes 10%, liquidity providers earn 90%
++  trading-fee  30
++  our-fungible-contract
  0x5856.b89a.1915.b17a.7bab.9be2.5bc7.7c47.1c9b.ffdf.79f6.5d13.8893.7ca3.137a.7d3e
::  before this contract is deployed, mint and distribute the treasury token.
::  this is a standard fungible token which grants the holder ownership of a
::  portion of the protocol's fee revenue. the holder can use the %offload
::  action to burn some amount of treasury tokens (sending them to this contract)
::  and will receive in return the equivalent % of fees earned in specified tokens.
++  treasury-token-metadata
  0x0  ::  put token metadata here
++  treasury-token-deployer
  0x0  ::  put address here
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
      $:  %swap
          pool-id=id
          payment=token-args
          receive=token-args
          ::  the account for the swap payment token
          ::  held by this contract, if any
          treasury-account=(unit id)
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
      $:  %offload  ::  TODO name better
          ::  exchange treasury token for proportional value
          ::  of each token held in the given treasury accounts.
          ::  note that caller must enumerate each token account
          ::  that treasury holds which they wish to receive a
          ::  portion of. this is to (a) not make AMM contract
          ::  have to track all its own accounts, and (b) to give
          ::  receivers the option not to receive certain tokens
          ::  they may not wish to hold.
          treasury-token=token-args
          treasury-accounts=(list token-args)
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