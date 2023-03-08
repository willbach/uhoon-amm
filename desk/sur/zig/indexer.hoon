/-  eng=zig-engine,
    seq=zig-sequencer
/+  smart=zig-sys-smart
::
|%
+$  query-type
  $?  %batch
      %batch-chain
      %batch-transactions
      %transaction
      %from
      %item
      %item-transactions
      %holder
      %source
      %to
      %town
      %hash
  ==
::
+$  query-payload
  ?(item-id=@ux [town-id=@ux item-id=@ux] location)
::
+$  location
  $?  second-order-location
      town-location
      batch-location
      transaction-location
  ==
+$  second-order-location  id:smart
+$  town-location  id:smart
+$  batch-location
  [town-id=id:smart batch-id=id:smart]
+$  transaction-location
  [town-id=id:smart batch-id=id:smart transaction-num=@ud]
::
+$  location-index
  (map @ux (jar @ux location))
+$  batch-index  ::  used for items
  (map @ux (jar @ux batch-location))
+$  transaction-index  ::  only ever one tx per id; -> (map (map))?
  (map @ux (jar @ux transaction-location))
+$  second-order-index
  (map @ux (jar @ux second-order-location))
::
+$  batches-by-town
  (map town-id=id:smart batches-and-order)
+$  batches-and-order
  [=batches =batch-order]
+$  batches
  (map id:smart [timestamp=@da =batch])
+$  batch-order
  (list id:smart)  ::  0-index -> most recent batch
+$  batch
  [transactions=processed-txs:eng town:seq]
+$  newest-batch-by-town
  %+  map  town-id=id:smart
  [batch-id=id:smart timestamp=@da =batch]
::
+$  town-update-queue
  (map town-id=@ux (map batch-id=@ux timestamp=@da))
+$  sequencer-update-queue
  (map town-id=@ux (map batch-id=@ux batch))
::
+$  base-state-1
  $:  %1
      =batches-by-town
      =capitol:seq
      =sequencer-update-queue
      =town-update-queue
      catchup-indexer=dock
  ==
::
+$  indices
  $:  =transaction-index
      from-index=second-order-index
      item-index=batch-index
      item-transactions-index=second-order-index
      holder-index=second-order-index
      source-index=second-order-index
      to-index=second-order-index
      =newest-batch-by-town
  ==
::
+$  inflated-state-1  [base-state-1 indices]
::
+$  batch-update-value
  [timestamp=@da location=town-location =batch]
+$  batch-chain-update-value
  [timestamp=@da location=town-location =chain:eng]
+$  batch-transactions-update-value
  $:  timestamp=@da
      location=town-location
      transactions=processed-txs:eng
  ==
+$  transaction-update-value
  $:  timestamp=@da
      location=transaction-location
      =transaction:smart
      =output:eng
  ==
+$  item-update-value
  [timestamp=@da location=batch-location =item:smart]
::
+$  update
  $@  ~
  $%  [%path-does-not-exist ~]
      [%batch batches=(map batch-id=id:smart batch-update-value)]
      [%batch-chain chains=(map batch-id=id:smart batch-chain-update-value)]
      [%batch-order =batch-order]
      [%batch-transactions transactions=(map batch-id=id:smart batch-transactions-update-value)]
      [%transaction transactions=(map transaction-id=id:smart transaction-update-value)]
      [%item items=(jar item-id=id:smart item-update-value)]
      $:  %hash
          batches=(map batch-id=id:smart batch-update-value)
          transactions=(map transaction-id=id:smart transaction-update-value)
          items=(jar item-id=id:smart item-update-value)
      ==
      [%newest-batch batch-id=id:smart batch-update-value]
      [%newest-batch-order batch-id=id:smart]
      [%newest-transaction transaction-id=id:smart transaction-update-value]
      [%newest-item item-id=id:smart item-update-value]
      ::  %newest-hash type is just %hash, since can have multiple
      ::  transactions/items, considering second-order indices
  ==
::
+$  consume-batch-args
  $:  batch-id=id:smart
      transactions=processed-txs:eng
      =town:seq
      timestamp=@da
      should-update-subs=?
  ==
++  action
  $%  [%set-catchup-indexer =dock]
      [%set-sequencer =dock]
      [%set-rollup =dock]
      [%bootstrap =dock]
      [%catchup =dock town-id=id:smart batch-id=id:smart]
      [%consume-batch args=consume-batch-args]
  ==
--
