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
  $%  
      [%set-our-address =address:smart]
      [%connect ~]                                                      ::   should only be called once due to sub duplicate. use %fetch to sync instead
      [%fetch ~]                                                    
      [%leave ~]                                                        ::  leave indexer sub, hopefully you won't have to use this.
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
      ::  might need origin receipts to display success/failure eventually
      $:  %deploy-token
           name=@t
           symbol=@t
           ::  salt=@ :: generated in app
           cap=(unit @ud)          ::  if ~, no cap (fr fr)
           minters=(set address:smart)  :: change to pset in /app 
           initial-distribution=(list [to=address:smart amount=@ud])
      ==
  ==
::
+$  update
  $%  [%confirmation token=@t amount=@ud]
      [%pools pools=(map id:smart pool-data)]
      [%txs txs=(list tx)]
      [%account account=(unit id:smart)]
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
+$  tx  :: %allowances & %liq-txs?
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