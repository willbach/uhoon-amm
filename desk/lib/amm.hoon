/-  *amm, indexer=zig-indexer, wallet=zig-wallet
/+  eng=zig-sys-engine
|%
++  fetch
  |_  [[our=ship now=@da] =address:smart amm-id=id:smart town=id:smart]
  ++  i-scry
    /(scot %p our)/uqbar/(scot %da now)/indexer
  ++  chain-state
    ^-  (map id:smart pool-data)
    ~&  >>  "%amm: fetching latest chain state"
    ::  scry the indexer
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/source/(scot %ux town)/(scot %ux amm-id)/noun
      ==
    ::  ~&  update
    ?@  update  ~
    ::  for each pool, parse
    ?:  ?=(%item -.update)
      =+  `(list item-update-value:indexer)`(zing ~(val by items.update))
      %-  ~(gas by *(map id:smart pool-data))
      %+  murn  -
      |=  item-update-value:indexer
      ?.  ?=(%& -.item)  ~
      ?~  p=(fill-pool ;;(pool:amm-lib noun.p.item))  ~
      `[id.p.item u.p]
    ::  parse single pool
    ?:  ?=(%newest-item -.update)
      ?>  ?=(%& -.item.update)
      ?~  p=(fill-pool ;;(pool:amm-lib noun.p.item.update))  ~
      [id.p.item.update^u.p ~ ~]
    ~  ::  got an unexpected update type
  ::
  ++  item-data
    |=  =id:smart
    ^-  (unit [source=id:smart *])
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/item/(scot %ux town)/(scot %ux id)/noun
      ==
    ?~  update  ~
    ?.  ?=(%newest-item -.update)  ~
    ?.  ?=(%& -.item.update)  ~
    `[source noun]:p.item.update
  ::
  ++  token-meta
    |=  =id:smart
    ^-  (unit [source=id:smart token-metadata:wallet])
    ?~  g=(item-data id)  ~
    ((soft ,[@ux ,token-metadata:wallet]) u.g)
  ::
  ++  get-token-account
    |=  [holder=address:smart meta-id=id:smart]
    ^-  (unit [id:smart token-account:wallet])
    ?~  found=(token-meta meta-id)  ~
    =+  id=(hash-data:eng source.u.found holder town salt.u.found)
    ?~  g=(item-data id)  ~
    ((soft ,[@ux token-account:wallet]) [id +.u.g])
  ::
  ++  get-token-account-info
    :: includes salt too, for signing approvals
    |=  [holder=address:smart meta-id=id:smart]
    ^-  (unit [id=id:smart token-account:wallet salt=@])
    ?~  found=(token-meta meta-id)  ~
    =+  id=(hash-data:eng source.u.found holder town salt.u.found)
    ?~  g=(item-data id)  ~
    ((soft ,[@ux token-account:wallet @]) [id +.u.g salt.u.found])
  ::
  ++  get-contract-account
    |=  [holder=address:smart meta-id=id:smart]
    ^-  (unit [id=id:smart source=id:smart])
    ?~  found=(token-meta meta-id)  ~
    =+  id=(hash-data:eng source.u.found holder town salt.u.found)
    ?~  g=(item-data id)  ~
    `[id source.u.found]
  ::
  ++  get-token-account-id
    |=  [holder=address:smart meta-id=id:smart]
    ^-  (unit id:smart)
    ?~  found=(token-meta meta-id)  ~
    =+  id=(hash-data:eng source.u.found holder town salt.u.found)
    ?~  g=(item-data id)  ~
    `id
  ++  get-contract
    |=  meta-id=id:smart
    ^-  (unit contract=id:smart)
    ?~  found=(token-meta meta-id)  ~
    `source.u.found
  ::
  ::  +fill-pool: take a pool's on-chain data and expand to give
  ::  everything we need to interact with it
  ::
  ++  fill-pool
    |=  raw=pool:amm-lib
    ^-  (unit pool-data)
    ::  ~&  >  "filling pool"
    ::  ~&  raw
    ::  gather metadata for each token in pool
    ?~  a=(token-meta meta.token-a.raw)  ~
    =*  metadata-a  +.u.a
    ?~  b=(token-meta meta.token-b.raw)  ~
    =*  metadata-b  +.u.b
    ?~  liq=(token-meta liq-token-meta.raw)  ~
    :-  ~
    :*  %-  crip  %-  zing
        :~  (trip symbol.metadata-a)  "-"
            (trip symbol.metadata-b)  " Pool"
        ==
        liq-shares.raw
        liq-token-meta.raw
      ::  our account for this liquidity token, if we have one
      (get-token-account address liq-token-meta.raw)
      :*  name.metadata-a
          symbol.metadata-a
          meta.token-a.raw
          ::  pool account item
          (get-token-account amm-id meta.token-a.raw)
          ::  our account item, if we have one
          (get-token-account address meta.token-a.raw)
          liq.token-a.raw
          (div (mul liq.token-a.raw dec-18:amm-lib) liq.token-b.raw)
      ==
      :*  name.metadata-b
          symbol.metadata-b
          meta.token-b.raw
          ::  pool account item
          (get-token-account amm-id meta.token-b.raw)
          ::  our account item, if we have one
          (get-token-account address meta.token-b.raw)
          liq.token-b.raw
          (div (mul liq.token-b.raw dec-18:amm-lib) liq.token-a.raw)
      ==
    ==
  --
::
++  transaction-poke
  |=  [our=ship call=wallet-poke:wallet]
  ^-  card:agent:gall
  ~&  call
  :*  %pass  /amm-wallet-poke
      %agent  [our %uqbar]
      %poke  %wallet-poke
      !>(call)
  ==
::
++  fungible-address  0x7abb.3cfe.50ef.afec.95b7.aa21.4962.e859.87a0.b22b.ec9b.3812.69d3.296b.24e1.d72a
--