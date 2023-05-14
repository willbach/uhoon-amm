/-  wallet=zig-wallet
/+  smart=zig-sys-smart
/=  amm-lib  /con/lib/amm
|%
::  [UQ| DAO]
::  App to interact with Uqbar AMM contract.
::  The app tracks pools and their prices, providing to the user an
::  interface for building transactions for swaps and liquidity management.
::
+$  state-1
  $:  %1
      our-town=@ux
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
      [%connect ~]
      [%leave ~]                             ::  leave indexer sub, hopefully you won't have to use this.
      $:  %start-pool
          token-a=[meta=id:smart amount=@ud]
          token-b=[meta=id:smart amount=@ud]
          deadline=@ud
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
          deadline=@ud
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
           minters=(set address:smart)  
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
+$  tx  :: %remove-liq too
  $:
    input=[meta=id:smart our=id:smart amount=@ud]
    output=[meta=id:smart our=id:smart amount=@ud]
    hash=(unit id:smart)
    status=?(%pending %failed %confirmed)
    desc=?(%start-pool %add-liq %swap)
    sigs=(pair (unit sig) (unit sig))
    approvals=(unit [deadline=@ud nonces=(pair @ud @ud)])
  ==
::
+$  sig  [v=@ r=@ s=@]
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
::  from con/lib/fungible
++  pull-jold-json  
  %-  need
  %-  de-json:html
  ^-  cord
  '''
  [
    {"from": "ux"},
    {"to": "ux"},
    {"amount": "ud"},
    {"nonce": "ud"},
    {"deadline": "ud"}
  ]
  '''
::  from con/lib/amm
++  get-pool-salt
  |=  [meta-a=id:smart meta-b=id:smart]
  ^-  @
  ?:  (gth meta-a meta-b)
    (cat 3 meta-a meta-b)
  (cat 3 meta-b meta-a)
::
::  might nuke state and remove these old vases, unnecessary
+$  state-0
  $: 
      our-town=@ux
      our-address=(unit @ux)
      amm-id=@ux
      pools=(map id:smart pool-data)
      txs=(list old-tx)
      pending-tx=(unit old-tx)
  ==
+$  old-tx 
  $:
    input=[meta=id:smart amount=@ud]
    hash=(unit id:smart)
    status=?(%pending %failed %confirmed)
    output=[meta=id:smart amount=@ud]
  == 
--