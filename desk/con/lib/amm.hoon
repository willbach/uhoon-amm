/+  *zig-sys-smart
|%
::  NOTE: PROTOCOL FEE IS COMMENTED OUT CURRENTLY
::
::  fee values (in basis points)
::  0.3% fee charged on swaps
++  trading-fee  30
++  our-fungible-contract
  0x68d8.2cfb.987e.5bd1.23a7.ee97.a2d6.9581.fff6.8f31.bf9f.f307.c046.9298.706c.71d8
::  before this contract is deployed, mint and distribute the treasury token.
::  this is a standard fungible token which grants the holder ownership of a
::  portion of the protocol's fee revenue. the holder can use the %offload
::  action to burn some amount of treasury tokens (sending them to this contract)
::  and will receive in return the equivalent % of fees earned in specified tokens.
::  ++  treasury-token-metadata
::    0x0  ::  put token metadata here
::  ++  treasury-token-deployer
::    0x0  ::  put address here
::
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
      from-account=id
  ==
::  from fungible standard
+$  token-account
  $:  balance=@ud
      allowances=(pmap address @ud)
      metadata=id
      nonces=(pmap address @ud)
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
      ==
  ::
      $:  %add-liq
          pool-id=id
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
      $:  %on-push    ::  we only support %swap and %remove-liq
          from=id     ::  here, because these are the only two actions
          amount=@ud  ::  that only require ONE token approval.
          calldata=*
      ==
  ::
  ::  $:  %offload  ::  TODO name better
  ::      ::  exchange treasury token for proportional value
  ::      ::  of each token held in the given treasury accounts.
  ::      ::  note that caller must enumerate each token account
  ::      ::  that treasury holds which they wish to receive a
  ::      ::  portion of. this is to (a) not make AMM contract
  ::      ::  have to track all its own accounts, and (b) to give
  ::      ::  receivers the option not to receive certain tokens
  ::      ::  they may not wish to hold.
  ::      treasury-token=token-args
  ::      treasury-accounts=(list token-args)
  ::  ==
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