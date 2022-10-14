/-  *amm, indexer
|%
++  fetch
  |_  [town-id=id:smart our=ship now=@da]
  ++  i-scry
    /(scot %p our)/uqbar/(scot %da now)/indexer
  ++  chain-state
    ^-  (map id:smart pool-data)
    ::  scry the indexer
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/lord/(scot %ux town-id)/(scot %ux amm-contract-id)/noun
      ==
    ?@  update  ~
    ::  for each pool, parse
    ?:  ?=(%grain -.update)
      ~
    ::  parse single pool
    ?:  ?=(%newest-grain -.update)
      ?>  ?=(%& -.grain.update)
      ?~  pool-one=(fill-pool ;;(pool data.p.grain.update))
        ~
      [id.p.grain.update^u.pool-one ~ ~]
    !!  ::  got an unexpected update type
  ::
  ++  grain-data
    |=  =id:smart
    ^-  (unit *)
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/grain/(scot %ux town-id)/(scot %ux id)/noun
      ==
    ?~  update  ~
    ?.  ?=(%newest-grain -.update)  ~
    ?.  ?=(%& -.grain.update)  ~
    `data.p.grain.update
  ::
  ++  token-meta
    |=  =id:smart
    ^-  (unit token-metadata)
    ?~  data=(grain-data id)  ~
    ((soft token-metadata) u.data)
  ::
  ++  token-account
    |=  =id:smart
    ^-  (unit account)
    ?~  data=(grain-data id)  ~
    ((soft account) u.data)
  ::
  ::  +fill-pool: take a pool's on-chain data and expand to give
  ::  everything we need to interact with it
  ::
  ++  fill-pool
    |=  raw=pool
    ^-  (unit pool-data)
    ::  gather metadata for each token in pool
    ?~  meta-a=(token-meta meta.token-a.raw)  ~
    ?~  meta-b=(token-meta meta.token-b.raw)  ~
    ~&  >  raw
    =/  pool-name=@t
      %-  crip  %-  zing
      :~  (trip symbol.u.meta-a)  "-"
          (trip symbol.u.meta-b)  " Pool"
      ==
    =/  token-a=token-data
      :*  name.u.meta-a
          symbol.u.meta-a
          meta.token-a.raw
          ~  ::  our-account-a
          ~  ::  pool-account-a
          liq.token-a.raw
          (div liq.token-a.raw liq.token-b.raw)
      ==
    =/  token-b=token-data
      :*  name.u.meta-b
          symbol.u.meta-b
          meta.token-b.raw
          ~  ::  our-account-b
          ~  ::  pool-account-b
          liq.token-b.raw
          (div liq.token-b.raw liq.token-a.raw)
      ==


    ~&  pool-name
    !!
    ::  =/  name  (zing "" "-" "")
  --
--