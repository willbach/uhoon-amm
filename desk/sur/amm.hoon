/-  wallet=zig-wallet
/+  smart=zig-sys-smart
/=  amm-lib  /con/lib/amm
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
      txs=(list tx)
      pending-tx=(unit tx)
  ==
::
+$  action
  $%  [%token-in token=@t amount=@ud]
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
      $:  %set-allowance
          token=[meta=id:smart amount=@ud]
      ==
  ==
::
+$  update
  $%  [%confirmation token=@t amount=@ud]
      [%pools pools=(map id:smart pool-data)]
      [%txs txs=(list tx)]
  ==
::
+$  pool-data
  $:  name=@t  ::  token A symbol + token B symbol
      liq-shares=@ud
      liq-token-meta=id:smart
      our-liq-token-account=(unit [=id:smart token-account:wallet])
      token-a=token-data
      token-b=token-data
  ==
::
+$  tx
  $:
    input=[meta=id:smart amount=@ud]
    hash=(unit id:smart)
    status=?(%pending %confirmed %failed)
    output=[meta=id:smart amount=@ud]
  ==
::
:: noun mold from con/lib/zigs or fungible
  +$  account
    $:  balance=@ud
        allowances=(pmap:smart address:smart @ud)
        metadata=id:smart
        nonces=(pmap:smart address:smart @ud)
    ==
::
+$  token-data
  $:  name=@t
      symbol=@t
      metadata=id:smart
      pool-account=(unit [=id:smart token-account:wallet])
      our-account=(unit [=id:smart token-account:wallet])
      liquidity=@ud
      current-price=@ud
  ==
--