/-  *amm, wallet=zig-wallet
/+  smart=zig-sys-smart
::
:: thought, instead of mapping pool objects by tokenid, map them by token1/token2 instead... hmm..
:: 
|%
++  enjs
  =,  enjs:format
  |%
    ++  update
      |=  up=^update
      ^-  json
      %+  frond  -.up
      ?-    -.up
          %confirmation
        %-  pairs
        :~  ['confirmation' (tape "Order Received: {<amount.up token.up>}")]
        ==
          %pools
        %-  pairs
        %+  turn  ~(tap by pools.up)
        |=  [=address:smart =pool-data]
        :-  `@tas`(rap 3 (scot %ux metadata.token-a.pool-data) '/' (scot %ux metadata.token-b.pool-data) ~)
        (enjs-pool pool-data address)    
      ==
    ::
    ++  enjs-pool
      |=  [pool=pool-data pooltoken=id:smart]
      ^-  json
      %-  pairs
      :~  [%name %s name.pool]
          [%address %s (scot %ux pooltoken)]
          [%liq-shares %s (scot %ud liq-shares.pool)]
          [%liq-token-meta %s (scot %ux liq-token-meta.pool)]
          [%our-liq-token-account %s 'soon bby']
          [%token-a (enjs-token-data token-a.pool)]
          [%token-b (enjs-token-data token-b.pool)]
      ==
    ::
    ++  enjs-token-data
      |=  token=token-data
      ^-  json
      %-  pairs
      :~  [%name %s name.token]
          [%symbol %s symbol.token]
          [%metadata %s (scot %ux metadata.token)]
          [%pool-account ?~(pool-account.token [%s ''] (enjs-token-account u.pool-account.token))]
          [%our-account ?~(our-account.token [%s ''] (enjs-token-account u.our-account.token))]
          [%liquidity %s (scot %ud liquidity.token)]
          [%current-price %s (scot %ud current-price.token)]
      ==  
    ::
    ++  enjs-token-account  :: reconsider whether we need all this, or what structure we should use.
      |=  [=id:smart ta=token-account:wallet]
      ^-  json
      %-  pairs
      :~  [%id %s (scot %ux id)]             :: todo better enjs unit cell logic
          [%balance %s (scot %ud balance.ta)]
          [%allowances (enjs-pmap allowances.ta)]
          [%metadata %s (scot %ux metadata.ta)]
          [%nonces (enjs-pmap nonces.ta)]
      ==  
    ::
    ++  enjs-pmap   :: current only (pmap:smart @ux @ud)
      |=  pm=(pmap:smart address:smart @ud)
      %-  pairs
      %+  turn  ~(tap py:pmap:smart pm)
      |=  [a=address:smart amount=@ud]
      [`@tas`(scot %ux a) %s (scot %ud amount)]

  --
--