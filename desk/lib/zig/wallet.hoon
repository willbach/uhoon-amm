/-  *zig-wallet, ui=zig-indexer
/+  ui-lib=zig-indexer
=>  |%
    +$  card  card:agent:gall
    --
|%
++  hash-transaction
  |=  [=calldata:smart =shell:smart]
  ::  hash the immutable+unique aspects of a transaction
  `@ux`(sham [calldata shell])
::
++  tx-update-card
  |=  in=[@ux transaction:smart supported-actions]
  ^-  card
  =+  `wallet-frontend-update`[%tx-status in]
  [%give %fact ~[/tx-updates] %wallet-frontend-update !>(-)]
::
++  finished-tx-update-card
  |=  in=[@ux finished-transaction]
  ^-  card
  =+  `wallet-frontend-update`[%finished-tx in]
  [%give %fact ~[/tx-updates] %wallet-frontend-update !>(-)]
::
++  notify-origin-card
  |=  [our=@p in=[@ux finished-transaction]]
  ^-  card
  ?~  origin.in  !!
  :*  %pass  q.u.origin.in
      %agent  [our p.u.origin.in]
      %poke  %wallet-update
      !>  ^-  wallet-update
      [%finished-transaction +.in]
  ==
::
++  get-sent-history
  |=  [=address:smart newest=? our=@p now=@da]
  ^-  (map @ux finished-transaction)
  =/  transaction-history=update:ui
    .^  update:ui
        %gx
        %+  weld  /(scot %p our)/indexer/(scot %da now)
        %+  weld  ?.  newest  /  /newest
        /from/0x0/(scot %ux address)/noun
    ==
  ?~  transaction-history  ~
  ?.  ?=(%transaction -.transaction-history)  ~
  %-  ~(urn by transactions.transaction-history)
  |=  [hash=@ux t=transaction-update-value:ui]
  ^-  finished-transaction
  :*  ~
      batch-id.location.t
      transaction.t(status (add 200 `@`status.transaction.t))
      [%noun calldata.transaction.t]
      output.t
  ==
::
++  watch-for-batches
  |=  [our=@p town=@ux]
  ^-  (list card)
  =-  [%pass /new-batch %agent [our %uqbar] %watch -]~
  /indexer/wallet/batch-order/(scot %ux town)
::
::  +integrate-output: upon receiving a transaction receipt,
::  analyze the output and update our tracked assets if any changed.
::
++  integrate-output
  |=  [tokens=(map address:smart book) =output:eng]
  ^+  tokens
  =/  burned=(list item:smart)    (turn ~(val by burned.output) tail)
  =/  modified=(list item:smart)  (turn ~(val by modified.output) tail)
  ::  remove any assets that were burned
  =.  tokens
    |-
    ?~  burned  tokens
    =*  item  i.burned
    ?~  held=(~(get by tokens) holder.p.item)
      $(burned t.burned)
    =-  $(burned t.burned, tokens -)
    (~(put by tokens) holder.p.item (~(del by u.held) id.p.item))
  ::  now replace any assets that were modified
  ::  NOTE: metadata for assets will still be tied to most recent
  ::  batch. if this becomes an issue, will need to add an asset
  ::  type that explains the ambiguity here.
  |-
  ?~  modified  tokens
  =*  item  i.modified
  ?~  held=(~(get by tokens) holder.p.item)
    $(modified t.modified)
  =-  $(modified t.modified, tokens -)
  =-  (~(put by tokens) holder.p.item (~(put by u.held) id.p.item -))
  ?.  ?=(%& -.item)
    ::  handle contract asset
    [%unknown town.p.item source.p.item ~]
  ::  determine type token/nft/unknown and store in book
  (discover-asset-mold town.p.item source.p.item noun.p.item)
::
::  +make-tokens: upon receiving a new batch update from indexer,
::  query indexer for items held by each of our tracked addresses
::  and create a view of those assets
::
++  make-tokens
  |=  [addrs=(list address:smart) our=@p now=@da]
  ^-  (map address:smart book)
  =|  new=(map address:smart book)
  |-  ::  scry for each tracked address
  ?~  addrs  new
  =/  upd  .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/holder/0x0/(scot %ux i.addrs)/noun)
  ?~  upd  $(addrs t.addrs)
  ?.  ?=(%item -.upd)
    ::  handle newest-item update type
    ?>  ?=(%newest-item -.upd)
    =/  single=asset
      ?.  ?=(%& -.item.upd)
        ::  handle contract asset
        [%unknown town.p.item.upd source.p.item.upd ~]
      ::  determine type token/nft/unknown
      (discover-asset-mold town.p.item.upd source.p.item.upd noun.p.item.upd)
      %=  $
        addrs  t.addrs
        new  (~(put by new) i.addrs (malt ~[[id.p.item.upd single]]))
      ==
  %=  $
    addrs  t.addrs
    new  (~(put by new) i.addrs (indexer-update-to-book upd))
  ==
::  +scan-transactions: upon receiving a new batch update, for each of our
::  token or NFT assets across all addresses, query the indexer for any
::  transactions in the new batch that affected these assets and add them
::  to our transaction-store.  (unify result with store)
::  NOTE: skip transactions that *failed*
++  scan-transactions
  |=  [tokens=(map address:smart book) our=@p now=@da]
  ^-  transaction-store
  =/  megabook=(list [id:smart asset])
    (zing (turn ~(val by tokens) |=(b=book ~(tap by b))))
  =|  res=transaction-store
  |-
  ?~  megabook  res
  =*  id  -.i.megabook
  =*  asset  +.i.megabook
  =/  upd
    .^  update:ui  %gx
      (scot %p our)  %uqbar  (scot %da now)
      /indexer/newest/item-transactions/0x0/(scot %ux id)/noun
    ==
  ?~  upd  $(megabook t.megabook)
  ?.  ?=(%transaction -.upd)
    ?.  ?=(%newest-transaction -.upd)
      $(megabook t.megabook)
    ::  handle single transaction: add to our store
    ::
    ?.  =(0 status.transaction.upd)
      $(megabook t.megabook)
    =.  status.transaction.upd  %300
    =.  res
      =*  a  address.caller.transaction.upd
      =/  outer  (~(gut by res) a ~)
      =-  (~(put by res) a (~(put by outer) transaction-id.upd -))
      [~ batch-id.location transaction noun+calldata.transaction output]:upd
    $(megabook t.megabook)
  ::  handle map of transactions: add all to our store
  ::
  =.  res
    =/  txns  ~(tap by transactions.upd)
    |-
    ?~  txns  res
    ?.  =(0 status.transaction.q.i.txns)
      $(txns t.txns)
    =.  status.transaction.q.i.txns  %300
    =*  a  address.caller.transaction.q.i.txns
    =/  outer  (~(gut by res) a ~)
    =-  $(res -, txns t.txns)
    =-  (~(put by res) a (~(put by outer) p.i.txns -))
    [~ batch-id.location transaction noun+calldata.transaction output]:q.i.txns
  $(megabook t.megabook)
::
++  indexer-update-to-book
  |=  =update:ui
  ^-  book
  ?>  ?=(%item -.update)
  =/  items-list=(list [@da =batch-location:ui =item:smart])
    (zing ~(val by items.update))
  =|  new-book=book
  |-  ^-  book
  ?~  items-list  new-book
  =*  item  item.i.items-list
  =/  =asset
    ?.  ?=(%& -.item)
      ::  handle contract asset
      [%unknown town.p.item source.p.item ~]
    ::  determine type token/nft/unknown and store in book
    (discover-asset-mold town.p.item source.p.item noun.p.item)
  %=  $
    items-list  t.items-list
    new-book  (~(put by new-book) id.p.item asset)
  ==
::
++  discover-asset-mold
  |=  [town=@ux contract=@ux data=*]
  ^-  asset
  =+  tok=((soft token-account) data)
  ?^  tok
    [%token town contract metadata.u.tok u.tok]
  =+  nft=((soft nft) data)
  ?^  nft
    [%nft town contract metadata.u.nft u.nft]
  [%unknown town contract data]
::
++  update-metadata-store
  |=  [tokens=(map address:smart book) =metadata-store our=@p now=@da]
  =/  book=(list [=id:smart =asset])
    %-  zing
    %+  turn  ~(val by tokens)
    |=(=book ~(tap by book))
  |-  ^-  ^metadata-store
  ?~  book  metadata-store
  =*  asset  asset.i.book
  ?-    -.asset
      ?(%token %nft)
    ?:  (~(has by metadata-store) metadata.asset)
      ::  already got metadata
      ::  TODO: determine schedule for updating asset metadata
      ::  (sub to indexer for the metadata item id, update our store on update)
      $(book t.book)
    ::  scry indexer for metadata item and store it
    ?~  meta=(fetch-metadata -.asset town.asset metadata.asset our now)
      ::  couldn't find it
      $(book t.book)
    %=  $
      book  t.book
      metadata-store  (~(put by metadata-store) metadata.asset u.meta)
    ==
  ::
      %unknown
    ::  can't find metadata if asset type is unknown
    $(book t.book)
  ==
::
++  fetch-metadata
  |=  [token-type=@tas town=@ux =id:smart our=ship now=time]
  ^-  (unit asset-metadata)
  ::  manually import metadata for a token
  =/  scry-res
    .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/item/(scot %ux town)/(scot %ux id)/noun)
  =/  g=(unit item:smart)
    ::  TODO remote scry w/ uqbar.hoon
    ?~  scry-res  ~
    ?.  ?=(%newest-item -.scry-res)  ~
    `item.scry-res
  ?~  g
    ~&  >>>  "%wallet: failed to find matching metadata for a item we hold"
    ~
  ?.  ?=(%& -.u.g)  ~
  ?+  token-type  ~
    %token  `[%token town source.p.u.g ;;(token-metadata noun.p.u.g)]
    %nft    `[%nft town source.p.u.g ;;(nft-metadata noun.p.u.g)]
  ==
::
::  JSON parsing utils
::
++  parsing
  =,  enjs:format
  |%
  ++  asset
    |=  [=id:smart =^asset]
    ^-  [p=@t q=json]
    :-  (scot %ux id)
    %-  pairs
    :~  ['id' [%s (scot %ux id)]]
        ['town' [%s (scot %ux town.asset)]]
        ['contract' [%s (scot %ux contract.asset)]]
        ['token_type' [%s (scot %tas -.asset)]]
        :-  'data'
        %-  pairs
        ?-    -.asset
            %token
          :~  ['balance' [%s (scot %ud balance.asset)]]
              ['metadata' [%s (scot %ux metadata.asset)]]
          ==
        ::
            %nft
          :~  ['id' [%s (scot %ud id.asset)]]
              ['uri' [%s uri.asset]]
              ['metadata' [%s (scot %ux metadata.asset)]]
              ['allowances' (address-set allowances.asset)]
              ['properties' (properties properties.asset)]
              ['transferrable' [%b transferrable.asset]]
          ==
        ::
            %unknown
          ~
        ==
    ==
  ::
  ++  metadata
    |=  [=id:smart m=asset-metadata]
    ^-  [p=@t q=json]
    :-  (scot %ux id)
    %-  pairs
    :~  ['id' [%s (scot %ux id)]]
        ['town' [%s (scot %ux town.m)]]
        ['token_type' [%s (scot %tas -.m)]]
        :-  'data'
        %-  pairs
        %+  snoc
          ^-  (list [@t json])
          :~  ['name' [%s name.m]]
              ['symbol' [%s symbol.m]]
              ['supply' [%s (scot %ud supply.m)]]
              ['cap' ?~(cap.m ~ [%s (scot %ud u.cap.m)])]
              ['mintable' [%b mintable.m]]
              ['minters' (address-set minters.m)]
              ['deployer' [%s (scot %ux deployer.m)]]
              ['salt' [%s (scot %ud salt.m)]]
          ==
        ?-  -.m
          %token  ['decimals' [%s (scot %ud decimals.m)]]
          %nft  ['properties' (properties-set properties.m)]
        ==
    ==
  ::
  ++  address-set
    |=  a=(set address:smart)
    ^-  json
    :-  %a
    %+  turn  ~(tap in a)
    |=(a=address:smart [%s (scot %ux a)])
  ::
  ++  properties-set
    |=  p=(set @tas)
    ^-  json
    :-  %a
    %+  turn  ~(tap in p)
    |=(prop=@tas [%s (scot %tas prop)])
  ::
  ++  properties
    |=  p=(map @tas @t)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by p)
    |=([prop=@tas val=@t] [prop [%s val]])
  ::
  ++  transaction-with-output
    |=  [hash=@ux f=finished-transaction]
    :-  (scot %ux hash)
    %-  pairs
    :~  ['transaction' (transaction hash transaction.f action.f)]
        ['batch' [%s (scot %ux batch.f)]]
        ['output' (output output.f)]
    ==
  ::
  ++  transaction-no-output
    |=  [hash=@ux =origin t=transaction:smart action=supported-actions]
    :-  (scot %ux hash)
    (transaction hash t action)
  ::
  ++  transaction
    |=  [hash=@ux t=transaction:smart action=supported-actions]
    ^-  json
    %-  pairs
    :~  ['hash' [%s (scot %ux hash)]]
        ['from' [%s (scot %ux address.caller.t)]]
        ['nonce' [%s (scot %ud nonce.caller.t)]]
        ['contract' [%s (scot %ux contract.t)]]
        ['rate' [%s (scot %ud rate.gas.t)]]
        ['budget' [%s (scot %ud bud.gas.t)]]
        ['town' [%s (scot %ux town.t)]]
        ['status' [%s (scot %ud status.t)]]
        :-  'action'
        %-  frond
        :-  (scot %tas -.action)
        %-  pairs
        ?-    -.action
            %give
          :~  ['to' [%s (scot %ux to.action)]]
              ['amount' [%s (scot %ud amount.action)]]
              ['item' [%s (scot %ux item.action)]]
          ==
        ::
            %give-nft
          :~  ['to' [%s (scot %ux to.action)]]
              ['item' [%s (scot %ux item.action)]]
          ==
        ::
            %text
          ~[['custom' [%s +.action]]]
        ::
            %noun
          ~[['custom' [%s (crip (noah !>(+.action)))]]]
        ==
    ==
  ::
  ++  output
    |=  o=output:eng
    ^-  json
    %-  pairs
    :~  ['gas' [%s (scot %ud gas.o)]]
        ['errorcode' [%s (scot %ud errorcode.o)]]
        ::  XX add when merging parsing libraries
    ==
  --
--
