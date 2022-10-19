/-  *amm
=,  format
|_  upd=update
++  grab
  |%
  ++  noun  update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ?-  -.upd
      %confirmation
      %-  pairs:enjs
      :~
        ['confirmation' (tape:enjs "Order Received: {<amount.upd token.upd>}")]
      ==
      ::
      %got-pool
      %-  pairs:enjs
      %+  turn  ~(tap by pools.upd)
      |=  [=address:smart =pool-data]
      :-  (scot %ux address)
      (parse-pool pool-data)      
    ==
  ++  parse-pool
    |=  pool=pool-data
    ^-  ^json
    %-  pairs:enjs
    :~  ['name' [%s name.pool]]
        ['liq-shares' [%s `@t`(scot %ud liq-shares.pool)]]
        ['our-liq-token-account' (parse-ux-unit our-liq-token-account.pool)]
        ['token-a' (parse-token-data token-a.pool)]
        ['token-b' (parse-token-data token-b.pool)]
    ==
  ::
  ++  parse-token-data
    |=  token=token-data
    ^-  ^json
    %-  pairs:enjs
    :~  ['name' [%s name.token]]
        ['symbol' [%s symbol.token]]
        ['metadata' [%s (scot %ux metadata.token)]]
        ['our-account' (parse-ux-unit our-account.token)]
        ['pool-account' (parse-ux-unit pool-account.token)]
        ['liquidity' [%s `@t`(scot %ud liquidity.token)]]
        ['current-price' [%n (scot %ud current-price.token)]]
    ==
  ::
  ++  parse-ux-unit
    |=  a=(unit @ux)
    ^-  ^json
    ?~  a  ~
    [%s (scot %ux u.a)]
  --
++  grad  %noun
--