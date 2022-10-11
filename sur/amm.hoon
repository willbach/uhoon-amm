/+  smart=zig-sys-smart
|%
::
::  App to interact with Uqbar AMM contract.
::
::  On init, the app subscribes to all grains controlled by the AMM contract,
::  the address of which is hardcoded below:
::
++  amm-contract-id  0xcafe
::
::  The app then tracks pools and their prices, providing to the user an
::  interface for building transactions for swaps and liquidity management.
::
+$  state-0
  $:  pools=(map id:smart pool-data)
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
  $:  token-a=[meta=id:smart liq=@ud]  ::  id of metadata grain
      token-b=[meta=id:smart liq=@ud]
      liq-shares=@ud
      liq-token-meta=id:smart
  ==
::
+$  contract-action
  $%  $:  %start-pool
          token-a=[meta=id:smart liq=@ud]
          token-b=[meta=id:smart liq=@ud]
      ==
  ::
      $:  %add-liq
          pool-id=id:smart
          token-a=[meta=id:smart liq=@ud]
          token-b=[meta=id:smart liq=@ud]
      ==
  ::
      $:  %remove-liq
          pool-id=id:smart
          liq-shares-account=id:smart
          amount=@ud
      ==
  ::
      $:  %swap
          pool-id=id:smart
          payment=[meta=id:smart amount=@ud]
          min-output=@ud
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
      nonce=@ud
  ==
--