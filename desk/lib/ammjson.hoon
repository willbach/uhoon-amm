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
        %txs
      a+(turn txs.up enjs-tx)
    ==
  ::
  ++  enjs-tx
    |=  =tx
    ^-  json
    %-  pairs
    :~  [%input (enjs-input input.tx)]
        [%hash %s ?~(hash.tx '' (scot %ux u.hash.tx))]
        [%output (enjs-output output.tx)]
    ==
  ++  enjs-input
    |=  [meta=id:smart amount=@ud]
    ^-  json
    %-  pairs
    :~  [%meta %s (scot %ux meta)]
        [%amount %s (scot %ud amount)]
    ==
  ++  enjs-output
    |=  [meta=id:smart amount=(unit @ud)]
    ^-  json
    %-  pairs
    :~  [%meta %s (scot %ux meta)]
        [%amount %s ?~(amount '' (scot %ud u.amount))]
    ==
  ++  enjs-pool
    |=  [pool=pool-data pooltoken=id:smart]
    ^-  json
    %-  pairs
    :~  [%name %s name.pool]
        [%address %s (scot %ux pooltoken)]
        [%liq-shares %s (scot %ud liq-shares.pool)]
        [%liq-token-meta %s (scot %ux liq-token-meta.pool)]
        [%our-liq-token-account ?~(our-liq-token-account.pool [%s ''] (enjs-token-account u.our-liq-token-account.pool))]
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
++  dejs
  =,  dejs:format
  |%
  ++  action
    |=  jon=json
    ^-  ^action
    =<  (decode jon)
    |%
    ++  decode
      %-  of
      :~  [%token-in dejs-tokenin]    :: remove
          [%set-our-address (se %ux)]
          :: [%connect ~]  mull-bonk-a mull-grow with this?
          [%start-pool dejs-startpool]
          [%swap dejs-swap]
          [%add-liq dejs-addliq]
          [%remove-liq dejs-removeliq]
      ==
    ++  dejs-startpool
      %-  ot
      :~  [%token-a dejs-token]
          [%token-b dejs-token]
      ==
    ++  dejs-tokenin
      %-  ot
      :~  [%token so]
          [%amount (se %ud)]
      ==
    ++  dejs-swap
      %-  ot
      :~  [%pool-id (se %ux)]
          [%payment dejs-token]
          [%receive dejs-token]
      ==
    ++  dejs-addliq
      %-  ot
      :~  [%pool-id (se %ux)]
          [%token-a dejs-token]
          [%token-b dejs-token]
      ==
    ++  dejs-token
      %-  ot
      :~  [%meta (se %ux)]
          [%amount (se %ud)]
      ==
    ++  dejs-removeliq
      %-  ot
      :~  [%pool-id (se %ux)]
          [%amount (se %ud)]
      ==
    --
  --
--