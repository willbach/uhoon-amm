/+  *amm, wallet=zig-wallet, default-agent, dbug, ammjson
|%
+$  versioned-state
  $%  state-0
      state-1
  ==
::
+$  card  card:agent:gall
::
--
=|  state-1
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
  =+  0x4e42.efe6.cf7c.2322.c82c.72a4.5912.a712.c338.f44a.5ab0.1bbc.5383.94fe.f64d.74fe
  %=  this
    our-town                    0x0
    our-address                 ~      
    amm-id                      -   :: on bacdun
    pools                       ~
    txs                         ~
    pending-tx                  ~
  ==
++  on-save  !>(state)
++  on-load
  |=  =vase
  ^-  (quip card _this)
  ::  interesting, %-  mole  |.  !<(state-0 vase)
  ?:  =(%1 -.q.vase)
    `this(state !<(state-1 vase))
  =/  old  !<(state-0 vase)
  =/  new  old(txs ~, pending-tx ~)
  `this(state [%1 new])
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
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%new-batch ~]
    ?:  ?=(%kick -.sign)
      :_  this  ::  attempt to re-sub
      =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
      /indexer/amm/batch-order/(scot %ux our-town.state)
                                ::  [%pass /new-batch %agent [our.bowl %uqbar] %leave ~]~
    ?.  ?=(%fact -.sign)  (on-agent:def wire sign)
    ::  new batch, fetch latest state from AMM contract
    ?~  our-address  `this
    =/  newpools  
      %~  chain-state  fetch
      [[our now]:bowl [u.our-address amm-id our-town]:state]
    ::
    :_  this(pools newpools)  :_  ~
    [%give %fact ~[/updates] %amm-update !>(`update`[%pools newpools])]  
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
    :_  state(pools newpools)  :_  ~
    [%give %fact ~[/updates] %amm-update !>(`update`[%pools newpools])]
  ::
      %leave
    :_  state  :_  ~
    [%pass /new-batch %agent [our.bowl %uqbar] %leave ~]
  ::
      %start-pool
    ?~  our-address
        ~|("must set address first!" !!)
    ::  pull our-token-accounts, nonces. sign approvals for tokens
    =/  our-token-a-account
      %-  need
      %.  [u.our-address meta.token-a.act]
      %~  get-token-account-info  fetch
      [[our now]:bowl u.our-address amm-id our-town]
    ::
    =/  our-token-b-account
      %-  need
      %.  [u.our-address meta.token-b.act]
      %~  get-token-account-info  fetch
      [[our now]:bowl u.our-address amm-id our-town]
      ::
    =/  nonce-a  (fall (~(get by nonces.our-token-a-account) u.our-address) 0)
    =/  nonce-b  (fall (~(get by nonces.our-token-b-account) u.our-address) 0)
    ::
    =/  message  [u.our-address amm-id amount.token-a.act nonce-a deadline.act]
    =/  pending
      :*  input=[meta.token-a.act id.our-token-a-account amount.token-a.act]
          ouput=[meta.token-b.act id.our-token-b-account amount.token-b.act]
          hash=~
          status=%pending
          desc=%start-pool
          sigs=[~ ~]
          approvals=(some [deadline.act [nonce-a nonce-b]])
      ==
    :_  state(pending-tx `pending)  :_  ~
    :*  %pass   /sign-approve
        %agent  [our.bowl %uqbar]
        %poke   %wallet-poke
        !>  ^-  wallet-poke:wallet
        :*  %sign-typed-message
            origin=`[%amm /sig-1] 
            from=u.our-address
            domain=id.our-token-a-account
            type=pull-jold-json
            message=message
    ==  ==
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
    =/  pending      :: do not necessarily have our-account for token yet. hash?
      :*  [meta.payment.act 0x0 amount.payment.act] 
          [meta.receive.act 0x0 amount.receive.act]
          ~               :: hash
          %pending        
          %swap           
          [~ ~]           :: sigs
          ~               :: approvals      
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
    ==  ==
      %deploy-token
    ?~  our-address
        ~|("must set address first!" !!)
    ::  pset ordering is different from set
    =/  minters  (make-pset:smart ~(tap in minters.act)) 
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
            minters
            initial-distribution.act
    ==  ==
  ::
      %add-liq
    ?~  our-address
        ~|("must set address first!" !!)
    ::  if we only track a subset, revise
    =+  pool=(~(got by pools) pool-id.act)
    =/  [token-a=token-data token-b=token-data]
      [token-a token-b]:pool
    ::
    =/  our-token-a  (need our-account.token-a)
    =/  our-token-b  (need our-account.token-b)
    =/  nonce-a  (fall (~(get by nonces.our-token-a) amm-id) 0)
    =/  nonce-b  (fall (~(get by nonces.our-token-b) amm-id) 0)
    ::
    =/  message  [u.our-address amm-id amount.token-a.act nonce-a deadline.act]
    =/  pending
      :*  input=[meta.token-a.act id.our-token-a amount.token-a.act]
          ouput=[meta.token-b.act id.our-token-b amount.token-b.act]
          hash=~
          status=%pending
          desc=%add-liq
          sigs=[~ ~]
          approvals=(some [deadline.act [nonce-a nonce-b]])
      ==
    :_  state(pending-tx `pending)  :_  ~
    :*  %pass   /sign-approve
        %agent  [our.bowl %uqbar]
        %poke   %wallet-poke
        !>  ^-  wallet-poke:wallet
        :*  %sign-typed-message
            origin=`[%amm /sig-1] 
            from=u.our-address
            domain=id.our-token-a
            type=pull-jold-json
            message=message
    ==  ==
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
    ==  ==  ==
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
    ==  ==
  ==
::
++  handle-wallet-update
  |=  update=wallet-update:wallet
  ^-  (quip card _state)
  ?+    -.update  `state
      %sequencer-receipt
    ?>  ?=(^ origin.update)
    ?~  our-address  ~|("need to set our-address before tx" !!)
    =/  modified=(list item:smart)  (turn ~(val by modified.output.update) tail)
    ?~  pending-tx   ~|  "no corresponding pending tx"  !!
    ::   note, pending txs that haven't yet gotten sequencer receipt would be good
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
      %give  %fact
      ~[/updates]
      %amm-update
      !>([%txs (snoc txs u.pending-tx)])
    ==
  ::
      %signed-message
    ?>  ?=(^ origin.update)
    ?~  our-address  ~|("need to set our-address before swap" !!)
    ?~  pending-tx   !!
    ?~  approvals.u.pending-tx  !!
    ?+    q.u.origin.update  ~|("got receipt from weird origin" !!)
        [%sig-1 ~]
      ::  todo, working =, for these
      =/  message
        :*  u.our-address
            amm-id
            amount.output.u.pending-tx
            p.nonces.u.approvals.u.pending-tx
            deadline.u.approvals.u.pending-tx
        ==
      =/  new  u.pending-tx(p.sigs `sig.update)
      :_  state(pending-tx `new)  :_  ~
      :*  %pass   /sign-approve
          %agent  [our.bowl %uqbar]
          %poke   %wallet-poke
          !>  ^-  wallet-poke:wallet
          :*  %sign-typed-message
              origin=`[%amm /sig-2] 
              from=u.our-address
              domain=our.output.u.pending-tx
              type=pull-jold-json
              message=message
      ==  ==
        [%sig-2 ~]
      ?~  p.sigs.u.pending-tx  !!
      =/  new  u.pending-tx(q.sigs `sig.update)
      =,  u.approvals.u.pending-tx
      =,  u.pending-tx
      ::  calculate pool-id in case we want to %add-liq
      =/  pool-id=id:smart  
      (hash-data:smart amm-id amm-id 0x0 (get-pool-salt meta.input meta.output))
      ::
      :_  state(pending-tx `new)  
      :_  ~
      %+  transaction-poke  our.bowl
      :*  %transaction
          origin=`[%amm /start-pool]
          from=u.our-address
          contract=amm-id
          town=our-town
          :-  %noun
          ^-  action:amm-lib
          ?<  ?=(%swap desc.u.pending-tx)
          ::  todo, revise conditional need
          ?:  =(desc %add-liq)
              :*  %add-liq
                  pool-id
                  [meta.input amount.input our.input]
                  [meta.output amount.output our.output]
                  [p.nonces deadline (need p.sigs)]
                  [q.nonces deadline sig.update]
              ==
          :*  %start-pool                   
              [meta.input amount.input our.input]
              [meta.output amount.output our.output]
              [p.nonces deadline (need p.sigs)]
              [q.nonces deadline sig.update]
      ==  ==
    ==
  ==
--
