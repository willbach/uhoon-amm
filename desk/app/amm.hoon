/+  *amm, wallet=zig-wallet, default-agent, dbug, ammjson
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  card  card:agent:gall
::
--
=|  state-0
=*  state  -
=<
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> [bowl ~])
::
++  on-init
  :-  ~
  ::  the AMM contract id
  =+  0xbd1.f4a1.b3eb.85b4.157f.bff2.3945.3ff8.8104.b8ac.425d.74f5.a799.d159.54a5.dc8b
  %=  this
    our-town                    0x0
    our-address                 ~       ::  our-addresses.... hmm... index for all? just scry wallet :DD
    amm-id                      -
    pools                       ~
    txs                         ~
    pending-tx                          ~
  ==
++  on-save  !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old-vase))
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
  ?+    mark  !!
      %amm-action
    (handle-frontend-poke:hc !<(action vase))
      %wallet-update
    (handle-wallet-update:hc !<(wallet-update:wallet vase))
  ==
  [cards this]
  ::
  --
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%updates ~]
    :_  this
    :~
      [%give %fact ~ %amm-update !>(`update`[%pools pools])]
      [%give %fact ~ %amm-update !>(`update`[%txs txs])]
      [%give %fact ~ %amm-update !>(`update`[%account our-address])]
    ==
  ==
::
++  on-agent :: todo, indexer updates flow immediately to frontend?
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%new-batch ~]
    ?:  ?=(%kick -.sign)
      :_  this  ::  attempt to re-sub, subscribe wire not unique, how to prevent this?
      =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
      /indexer/amm/batch-order/(scot %ux our-town.state)
                                                                  ::  [%pass /new-batch %agent [our.bowl %uqbar] %leave ~]~
    ?.  ?=(%fact -.sign)  (on-agent:def wire sign)
    ::  new batch, fetch latest state from AMM contract
    ?~  our-address  `this
    ::  
    ::
    ::
    =/  newpools  
      %~  chain-state  fetch
      [[our now]:bowl [u.our-address amm-id our-town]:state]
    ::
    :_  this(pools newpools)
    :~  [%give %fact ~[/updates] %amm-update !>(`update`[%pools newpools])]  
    ==
  ==
  ::
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
::
++  handle-frontend-poke
  |=  act=action
  ^-  (quip card _state)
  ?-    -.act
      %set-our-address
    `state(our-address `address.act)
  ::
      %connect
    ?~  our-address
        ~|("must set address first!" !!)
    =/  newpools  
      %~  chain-state  fetch
      [[our now]:bowl [u.our-address amm-id our-town]:state]
    ::
    =/  indexer-sub  (~(get by wex.bowl) [/new-batch our.bowl %uqbar])
    ?~  indexer-sub
      :-  =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
        /indexer/amm/batch-order/(scot %ux our-town)
      state(pools newpools)
    :: indexer sub might already exist, just scry in this case
    :: ?:  =((need indexer-sub) [%.y /indexer/amm/batch-order/our-town]), doens't matter, just scry
    :_  state(pools newpools)
    :~  [%give %fact ~[/updates] %amm-update !>(`update`[%pools newpools])]
    ==
      
  ::
      %leave
    :_  state
    :~  [%pass /new-batch %agent [our.bowl %uqbar] %leave ~]
    ==
  ::
      %start-pool
    ?~  our-address
        ~|("must set address first!" !!)
    ::  given token-a and token-b, fetch our accounts and pool accounts,
    ::  then generate transaction to AMM contract
    =/  our-token-a-account=id:smart
      %-  need
      %.  [u.our-address meta.token-a.act]
      %~  get-token-account-id  fetch
      [[our now]:bowl u.our-address amm-id our-town]
    ::
    =/  our-token-b-account=id:smart
      %-  need
      %.  [u.our-address meta.token-b.act]
      %~  get-token-account-id  fetch
      [[our now]:bowl u.our-address amm-id our-town]
    ::
    :_  state  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=~
        from=u.our-address
        contract=amm-id
        town=our-town
        :-  %noun
        ^-  action:amm-lib
        :+  %start-pool
          [meta.token-a.act amount.token-a.act our-token-a-account]
        [meta.token-b.act amount.token-b.act our-token-b-account]
    ==
  ::  
      %swap
    ?~  our-address
        ~|("must set address first!" !!)
    =+  pool=(~(got by pools) pool-id.act)
    ::
    =/  [payment=token-data receive=token-data]
      ?:  =(metadata.token-a.pool meta.payment.act)
        [token-a token-b]:pool
      [token-b token-a]:pool
    ::
    =/  contract-id
      %-  need
      %.  metadata.payment
      %~  get-contract  fetch
      [[our now]:bowl u.our-address amm-id our-town]
    ::
    =/  pending  :*  [meta.payment.act amount.payment.act]                    :: input
                     ~                                                        :: hash
                     %pending                                                 :: status
                     [meta.receive.act amount.receive.act]                    :: unit output, try with newly deployed token, see what happens. 
                 ==                
    :_  state(pending-tx `pending)  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=`[%amm /new-swap]
        from=u.our-address
        contract=contract-id
        town=our-town
        :-  %noun
        :*        
              %push        :: note the ordering of the inputs
              to=amm-id
              amount=amount.payment.act
              from-account=id:(need our-account.payment)
            ::
              ^-  action:amm-lib
              :^    %swap     
                  pool-id.act
                [metadata.payment amount.payment.act -:(need our-account.payment)]
              [metadata.receive amount.receive.act -:(need pool-account.receive)]
        ==
    ==
      %deploy-token
    ?~  our-address
        ~|("must set address first!" !!)
    :_  state  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=~
        from=u.our-address
        contract=fungible-address
        town=our-town
        :-  %noun
        :*  %deploy-token
            name.act
            symbol.act
            (cat 3 name.act symbol.act)
            cap.act
            `(pset:smart address:smart)`minters.act
            initial-distribution.act
        ==
    ==
  ::
      %add-liq
    ?~  our-address
        ~|("must set address first!" !!)
    =+  pool=(~(got by pools) pool-id.act)
    ::
    =/  [token-a=token-data token-b=token-data]
      [token-a token-b]:pool
    ::
    :_  state  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=~
        from=u.our-address
        contract=amm-id
        town=our-town
        :-  %noun
        ^-  action:amm-lib
        :^    %add-liq
            pool-id.act
          [metadata.token-a amount.token-a.act -:(need our-account.token-a)]
        [metadata.token-b amount.token-b.act -:(need our-account.token-b)]
    ==
  ::
      %remove-liq
    ?~  our-address
        ~|("must set address first!" !!)
    =+  pool=(~(got by pools) pool-id.act)
    =/  [token-a=token-data token-b=token-data]
      [token-a token-b]:pool
    ::
    =/  contract-id
      %-  need
      %.  liq-token-meta.pool
      %~  get-contract  fetch
      [[our now]:bowl u.our-address amm-id our-town]
    :: TODO: don't necessarily need an extra scry, this is just the fungible contract 
    ::
    :_  state  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=~
        from=u.our-address
        contract=contract-id
        town=our-town
        :-  %noun
        :*  %push
            to=amm-id
            amount=amount.act
            from-account=id:(need our-liq-token-account.pool)
            ^-  action:amm-lib
            :*  %remove-liq
                pool-id.act
                id:(need our-liq-token-account.pool)
                amount.act
                [metadata.token-a -:(need pool-account.token-a)]
                [metadata.token-b -:(need pool-account.token-b)]
            ==
        ==
    ==
  ::
      %set-allowance
    ?~  our-address
        ~|("must set address first!" !!)
    =/  token-account
      %-  need
      %.  [u.our-address meta.token.act]
      %~  get-contract-account  fetch
      [[our now]:bowl u.our-address amm-id our-town]
    ::
    :_  state  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=~
        from=u.our-address
        contract=source.token-account
        town=our-town
        :-  %noun
        ::^-  action:amm-lib
        :*  %set-allowance
            amm-id
            amount.token.act
            id.token-account
        ==
    ==
  ==
::
++  handle-wallet-update
  |=  update=wallet-update:wallet
  ^-  (quip card _state)
  ?+    -.update  `state
      %sequencer-receipt
    ?>  ?=(^ origin.update)
    ?~  our-address  ~|  "need to set our-address before swap"  !!
    ::
    ?+    q.u.origin.update  ~|("got receipt from weird origin" !!)
        [%new-swap ~]
      =/  modified=(list item:smart)  (turn ~(val by modified.output.update) tail)
      ?~  pending-tx   ~|  "no corresponding pending tx"  !!
      ::   note, pending txs that haven't yet gotten sequencer receipt would be good
      ::
      ?.   =(%0 errorcode.output.update)
        =:  hash.u.pending-tx    `hash.update
            status.u.pending-tx  %failed
        ==
        :_  state(txs (snoc txs u.pending-tx), pending-tx ~)
        :_  ~
        :*  %give
            %fact
            ~[/updates]
            %amm-update
            !>([%txs (snoc txs u.pending-tx)])
        ==
      :: 
      ::  
      =:  hash.u.pending-tx     `hash.update
          status.u.pending-tx   %confirmed
      ==
      :_  state(txs (snoc txs u.pending-tx), pending-tx ~)
      :_  ~
      :*
        %give
        %fact
        ~[/updates]
        %amm-update
        !>([%txs (snoc txs u.pending-tx)])
      ==
    ==
  ==
--