/-  *amm
|_  act=action
++  grab
  |%
  ++  noun  action
  ++  json
    =,  dejs:format
    |=  jon=json
    %-  action
    =<  (fe-action jon)
    |%
    ++  fe-action
      %-  of
      :: :~  fe-test+(ot ~[squid+ni])
      :~  
          [%fe-test ni]
          [%token-in (ot ~[[%token so] [%amount ni]])]
          [%make-pool parse-pool]
      ==
    ++  parse-pool
      %-  ot
      :~  [%name so]
          [%liq-shares ni]
          [%liq-token-meta (se %ux)]
          [%our-liq-token-account (mu (se %ux))]
          [%token-a parse-token]
          [%token-b parse-token]
      ==
    ++  parse-token
      %-  ot
      :~  [%name so]
          [%symbol so]
          [%metadata (se %ux)]
          [%our-account (mu (se %ux))]
          [%pool-account (mu (se %ux))]
          [%liquidity ni]
          [%current-price ni]
      ==
    --
  --
++  grow
  |%
  ++  noun  act
  --
++  grad  %noun
--