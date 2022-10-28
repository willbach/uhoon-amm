/-  *amm, indexer=zig-indexer
|%
++  fetch
  |_  [our-addr=address:smart town-id=id:smart our=ship now=@da]
  ++  i-scry
    /(scot %p our)/uqbar/(scot %da now)/indexer
  ++  chain-state
    ^-  (map id:smart pool-data)
    ::  scry the indexer
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/source/(scot %ux town-id)/(scot %ux amm-contract-id)/noun
      ==
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
    !!  ::  got an unexpected update type
  ::
  ++  item-data
    |=  =id:smart
    ^-  (unit [source=id:smart *])
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/item/(scot %ux town-id)/(scot %ux id)/noun
      ==
    ?~  update  ~
    ?.  ?=(%newest-item -.update)  ~
    ?.  ?=(%& -.item.update)  ~
    `[source noun]:p.item.update
  ::
  ++  token-meta
    |=  =id:smart
    ^-  (unit [source=id:smart token-metadata])
    ?~  g=(item-data id)  ~
    ((soft ,[@ux ,token-metadata]) u.g)
  ::
  ++  token-account
    |=  =id:smart
    ^-  (unit [source=id:smart account])
    ?~  g=(item-data id)  ~
    ((soft ,[@ux account]) u.g)
  ::
  ::  +fill-pool: take a pool's on-chain data and expand to give
  ::  everything we need to interact with it
  ::
  ++  fill-pool
    |=  raw=pool
    ^-  (unit pool-data)
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
      =-  ?~((item-data -) ~ `-)
      (hash-data:smart -.u.liq our-addr town-id salt.+.u.liq)
      :*  name.metadata-a
          symbol.metadata-a
          meta.token-a.raw
          ::  our account item, if we have one
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.a our-addr town-id salt.metadata-a)
          ::  pool account item
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.a amm-contract-id town-id salt.metadata-a)
          liq.token-a.raw
          (div liq.token-a.raw liq.token-b.raw)
      ==
      :*  name.metadata-b
          symbol.metadata-b
          meta.token-b.raw
          ::  our account item, if we have one
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.b our-addr town-id salt.metadata-b)
          ::  pool account item
          =-  ?~((item-data -) ~ `-)
          (hash-data:smart -.u.b amm-contract-id town-id salt.metadata-b)
          liq.token-b.raw
          (div liq.token-b.raw liq.token-a.raw)
      ==
    ==
  --
--