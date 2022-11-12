/+  smart=zig-sys-smart
|%
::
::  App to interact with Uqbar AMM contract.
::  The app tracks pools and their prices, providing to the user an
::  interface for building transactions for swaps and liquidity management.
::
+$  state-0
  $:  our-town=@ux
      our-address=(unit @ux)
      amm-id=@ux
      pools=(map id:smart pool-data)
  ==
::
+$  action
  $%  [%fe-test num=@ud]
      [%token-in token=@t amount=@ud]
      [%make-pool pool-data]
      [%get-pool ~]
      ::
      [%set-our-address =address:smart]
      [%connect ~]  ::  start watching AMM contract through indexer
      $:  %start-pool
          token-a=[meta=id:smart amount=@ud]
          token-b=[meta=id:smart amount=@ud]
      ==
      $:  %swap
          pool-id=id:smart
          payment=[meta=id:smart amount=@ud]
          receive=[meta=id:smart amount=@ud]
      ==
      $:  %add-liq
          pool-id=id:smart
          token-a=[meta=id:smart amount=@ud]
          token-b=[meta=id:smart amount=@ud]
      ==
      $:  %remove-liq
          pool-id=id:smart
          amount=@ud
      ==
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