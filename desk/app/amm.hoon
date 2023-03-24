/+  *amm, wallet=zig-wallet, default-agent, dbug
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
    our-address                 ~
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
    ==
  ==
::
++  on-agent :: todo, indexer updates flow immediately to frontend?
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%new-batch ~]
    ?:  ?=(%kick -.sign)
      :_  this  ::  attempt to re-sub
      =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
      /indexer/amm/batch-order/(scot %ux our-town.state)
    ?.  ?=(%fact -.sign)  (on-agent:def wire sign)
    ::  new batch, fetch latest state from AMM contract
    ?~  our-address  `this
    =/  newpools  
      %~  chain-state  fetch
      [[our now]:bowl [u.our-address amm-id our-town]:state]
    ::
    :_  this(pools newpools)
    :~  [%give %fact ~[/updates] %amm-update !>(`update`[%pools newpools])]  
    ==
  ==
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
      %token-in
    :_  state
    ~[[%give %fact ~[/testpath] %amm-update !>([%confirmation token.act amount.act])]]
  ::
      %set-our-address
    `state(our-address `address.act)
  ::
      %connect
    ?~  our-address
      ~|("must set address first!" !!)
    :-  =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
        /indexer/amm/batch-order/(scot %ux our-town)
    %=    state
        pools
      %~  chain-state  fetch
      [[our now]:bowl u.our-address amm-id our-town]
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
    ?~  pool=(~(get by pools) pool-id.act)
      ~|("pool for that swap not found!" !!)
    =/  [payment=token-data receive=token-data]
      ?:  =(metadata.token-a.u.pool meta.payment.act)
        [token-a token-b]:u.pool
      [token-b token-a]:u.pool
    ::
    =/  pending  :*  :-  [meta.payment.act amount.payment.act] :: input
                         [meta.receive.act amount.receive.act]
                     ~                                         :: hash
                     ~                                         :: unit output
                 ==                
    :_  state(pending-tx `pending)  :_  ~
    %+  transaction-poke  our.bowl
    :*  %transaction
        origin=`[%amm /new-swap]
        from=u.our-address
        contract=amm-id
        town=our-town
        :-  %noun
        ^-  action:amm-lib
        :^    %swap
            pool-id.act
          [metadata.payment amount.payment.act -:(need our-account.payment)]
        [metadata.receive amount.receive.act -:(need pool-account.receive)]
    ==
  ::
      %add-liq
    ?~  our-address
      ~|("must set address first!" !!)
    ?~  pool=(~(get by pools) pool-id.act)
      ~|("pool for this action not found!" !!)
    =/  [token-a=token-data token-b=token-data]
      [token-a token-b]:u.pool
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
    ?~  pool=(~(get by pools) pool-id.act)
      ~|("pool for this action not found!" !!)
    =/  [token-a=token-data token-b=token-data]
      [token-a token-b]:u.pool
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
        :*  %remove-liq
            pool-id.act
            -:(need our-liq-token-account.u.pool)
            amount.act
            [metadata.token-a -:(need pool-account.token-a)]
            [metadata.token-b -:(need pool-account.token-b)]
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
    ?~  our-address  ~|  "need to set our-address before swapping?"  !!
    ::
    ?+    q.u.origin.update  ~|("got receipt from weird origin" !!)
        [%new-swap ~]
      ::  this method basically works, but there's some sneaky logic tbd with regard to the difference in zigs & fungibles
      =/  modified=(list item:smart)  (turn ~(val by modified.output.update) tail)
      ~&  >>>  "{<modified>}"
      ::
      ?~  pending-tx   ~|  "no corresponding pending tx"  !!  
      ::
      =|  outp=token-amounts   
      =/  dummy  %+  turn  modified
      |=  i=item:smart
      ?.  ?=(%& -.i)  ~                       :: todo not item? /failed tx?
      ~&  "holder?: {<holder.p.i>}"
      ~&  "label: {<label.p.i>}"
      ~&  "noun: {<noun.p.i>}"
      ?:  ?&  =(holder.p.i u.our-address)
              =(label.p.i %account)
          ==
          =/  acc  ;;(account noun.p.i)           :: dangerous? how else to mold incoming
          ~&  "id: {<id.p.i>}"
          ~&  "balance: {<balance.acc>}"
          ?:  =(source.p.i meta.token-a.input.u.pending-tx)  outp(token-a [source.p.i balance.acc])
          ?:  =(source.p.i meta.token-b.input.u.pending-tx)  outp(token-b [source.p.i balance.acc])
        ::
        ~
      ~
      ~&  "formatted: {<outp>}"
      `state
      :: 
    ==
  ==
--