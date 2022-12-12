/-  *amm, indexer=zig-indexer, wallet=zig-wallet
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
    ~&  update
    ?@  update  ~
    ::  for each pool, parse
    ?:  ?=(%item -.update)
      =+  `(list item-update-value:indexer)`(zing ~(val by items.update))
      %-  ~(gas by *(map id:smart pool-data))
      %+  murn  -
      |=  item-update-value:indexer
      ?.  ?=(%& -.item)  ~
      ?~  p=(fill-pool ;;(pool noun.p.item))  ~
      `[id.p.item u.p]
    ::  parse single pool
    ?:  ?=(%newest-item -.update)
      ?>  ?=(%& -.item.update)
      ?~  p=(fill-pool ;;(pool noun.p.item.update))  ~
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
  ++  token-account
    |=  =id:smart
    ^-  (unit [source=id:smart token-account:wallet])
    ?~  g=(item-data id)  ~
    ((soft ,[@ux token-account:wallet]) u.g)
  ::
  ++  get-token-account-id
    |=  [holder=address:smart meta-id=id:smart]
    ^-  (unit id:smart)
    ?~  found=(token-meta meta-id)  ~
    =+  (hash-data:smart source.u.found holder town salt.u.found)
    ?~  (token-account -)  ~  `-
  ::
  ::  +fill-pool: take a pool's on-chain data and expand to give
  ::  everything we need to interact with it
  ::
  ++  fill-pool
    |=  raw=pool
    ^-  (unit pool-data)
    ~&  >  "filling pool"
    ~&  raw
    ::  gather metadata for each token in pool
    ?~  a=(token-meta meta.token-a.raw)  ~
    ~&  >  "a"
    =*  metadata-a  +.u.a
    ?~  b=(token-meta meta.token-b.raw)  ~
    ~&  >  "b"
    =*  metadata-b  +.u.b
    ?~  liq=(token-meta liq-token-meta.raw)  ~
    ~&  >  "c"
    :-  ~
    :*  %-  crip  %-  zing
        :~  (trip symbol.metadata-a)  "-"
            (trip symbol.metadata-b)  " Pool"
        ==
        liq-shares.raw
        liq-token-meta.raw
      ::  our account for this liquidity token, if we have one
      =-  ?~((item-data -) ~ `-)
      (hash-data:smart -.u.liq address town salt.+.u.liq)
      :*  name.metadata-a
          symbol.metadata-a
          meta.token-a.raw
          ::  our account item, if we have one
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.a amm-id town salt.metadata-a)
          ::  pool account item
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.a address town salt.metadata-a)
          liq.token-a.raw
          (div liq.token-a.raw liq.token-b.raw)
      ==
      :*  name.metadata-b
          symbol.metadata-b
          meta.token-b.raw
          ::  our account item, if we have one
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.b amm-id town salt.metadata-b)          
          ::  pool account item
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.b address town salt.metadata-b)
          liq.token-b.raw
          (div liq.token-b.raw liq.token-a.raw)
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
--