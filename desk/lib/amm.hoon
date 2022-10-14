/-  *amm, indexer
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
    ^-  (unit [lord=id:smart *])
    =/  =update:indexer
      .^  update:indexer  %gx
          %+  weld  i-scry
          /newest/grain/(scot %ux town-id)/(scot %ux id)/noun
      ==
    ?~  update  ~
    ?.  ?=(%newest-grain -.update)  ~
    ?.  ?=(%& -.grain.update)  ~
    `[lord data]:p.grain.update
  ::
  ++  token-meta
    |=  =id:smart
    ^-  (unit [lord=id:smart token-metadata])
    ?~  g=(grain-data id)  ~
    ((soft ,[@ux ,token-metadata]) u.g)
  ::
  ++  token-account
    |=  =id:smart
    ^-  (unit [lord=id:smart account])
    ?~  g=(grain-data id)  ~
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
      =-  ?~((grain-data -) ~ `-)
      (fry-rice:smart -.u.liq our-addr town-id salt.+.u.liq)
      :*  name.metadata-a
          symbol.metadata-a
          meta.token-a.raw
          ::  our account grain, if we have one
          =-  ?~((grain-data -) ~ `-)
          (fry-rice:smart -.u.a our-addr town-id salt.metadata-a)
          ::  pool account grain
          =-  ?~((grain-data -) ~ `-)
          (fry-rice:smart -.u.a amm-contract-id town-id salt.metadata-a)
          liq.token-a.raw
          (div liq.token-a.raw liq.token-b.raw)
      ==
      :*  name.metadata-b
          symbol.metadata-b
          meta.token-b.raw
          ::  our account grain, if we have one
          =-  ?~((grain-data -) ~ `-)
          (fry-rice:smart -.u.b our-addr town-id salt.metadata-b)
          ::  pool account grain
          =-  ?~((grain-data -) ~ `-)
          (fry-rice:smart -.u.b amm-contract-id town-id salt.metadata-b)
          liq.token-b.raw
          (div liq.token-b.raw liq.token-a.raw)
      ==
    ==
  --
--