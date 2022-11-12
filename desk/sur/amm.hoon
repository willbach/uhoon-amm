/+  smart=zig-sys-smart
|%
::
::  App to interact with Uqbar AMM contract.
::
::  On init, the app subscribes to all grains controlled by the AMM contract,
::  the address of which is hardcoded below:
::
++  our-addr  ::  for testing
  0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
++  amm-contract-id
  0x4d78.fd37.70db.a302.6ad1.c3e1.3517.dbfc.35db.7160.1e9c.d630.0dd0.c02b.ff13.054c
++  our-town-id  0x0
::  fungible contract id:
::  0x1243.45f7.fca9.a019.1c65.1316.bffa.10d6.cdb8.42e6.06fe.0f79.a3ee.e5a2.ca63.3327
::
::  The app then tracks pools and their prices, providing to the user an
::  interface for building transactions for swaps and liquidity management.
::
+$  state-0
  $:  pools=(map id:smart pool-data)
  ==
::
+$  action
  $%  [%fe-test num=@ud]
      [%token-in token=@t amount=@ud]
      [%make-pool pool-data]
      [%get-pool ~]
  ==
::
+$  update
  $%  [%confirmation token=@t amount=@ud]
      [%got-pool pools=(map id:smart pool-data)]
  ==
::
+$  pool-data
  $:  name=@t  ::  token A symbol + token B symbol
      liq-shares=@ud
      liq-token-meta=id:smart
      our-liq-token-account=(unit id:smart)
      token-a=token-data
      token-b=token-data
  ==
::
+$  token-data
  $:  name=@t
      symbol=@t
      metadata=id:smart
      our-account=(unit id:smart)
      pool-account=(unit id:smart)
      liquidity=@ud
      current-price=@ud
  ==
::
::  Types from AMM contract:
::
+$  pool
  $:  token-a=[meta=id:smart contract=id:smart liq=@ud]
      token-b=[meta=id:smart contract=id:smart liq=@ud]
      liq-shares=@ud
      liq-token-meta=id:smart
  ==
::
+$  token-args
  $:  meta=id:smart
      amount=@ud
      pool-account=(unit id:smart)
      caller-account=(unit id:smart)
  ==
::
+$  contract-action
  $%  $:  %start-pool
          token-a=token-args
          token-b=token-args
      ==
  ::
      $:  %swap
          pool-id=id:smart
          payment=token-args
          receive=token-args
          ::  the account for the swap payment token
          ::  held by this contract, if any
          treasury-account=(unit id:smart)
      ==
  ::
      $:  %add-liq
          pool-id=id:smart
          liq-shares-account=(unit id:smart)
          token-a=token-args
          token-b=token-args
      ==
  ::
      $:  %remove-liq
          pool-id=id:smart
          liq-shares-account=id:smart
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
::  Types from Fungible token standard:
::
+$  token-metadata
  $:  name=@t                 ::  the name of a token (not unique!)
      symbol=@t               ::  abbreviation (also not unique)
      decimals=@ud            ::  granularity (maximum defined by implementation)
      supply=@ud              ::  total amount of token in existence
      cap=(unit @ud)          ::  supply cap (~ if no cap)
      mintable=?              ::  whether or not more can be minted
      minters=(pset:smart address:smart)  ::  pubkeys permitted to mint, if any
      deployer=address:smart        ::  pubkey which first deployed token
      salt=@                  ::  deployer-defined salt for account grains
  ==
::
+$  account
  $:  balance=@ud
      allowances=(pmap:smart address:smart @ud)
      metadata=id:smart
      nonces=(map address:smart @ud)
  ==
--