/+  *amm, default-agent, dbug
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
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  :-  ~
  =+  0x6f5a.2618.4e0c.00ac.0141.04c7.24fb.a3a0.5016.5270.b179.30c9.3d66.1d1c.860a.7a56
  %=  this
    our-town                    0x0
    our-address                 ~
    amm-id                      -
    pools                       ~
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
    (handle-frontend-poke !<(action vase))
  ==
  [cards this]
  ::
  ++  handle-frontend-poke
    |=  act=action
    ^-  (quip card _state)
    ?-    -.act
        %fe-test
      ~&  >>  "init FE poke {<state>}"
      `state
    ::
        %token-in
      :: ~&  >  act
      :_  state
      ~[[%give %fact ~[/testpath] %amm-update !>([%confirmation token.act amount.act])]]
    ::
        %make-pool
      :: =+  %-  %~  put  by
      ::     *(map id:smart pool-data)
      ::     [0x17 ;;(pool-data +.act)]
      :: ~&  >  state
      `state
    ::
        %get-pool
      :: ~&  >  pools.state
      :_  state
      ~[[%give %fact ~[/pools] %amm-update !>([%got-pool state])]]
    ::
    ::
        %set-our-address
      :-  ~
      %=    state
        our-address  `address.act
          pools
        %~  chain-state  fetch
        [[our now]:bowl address.act amm-id our-town]
      ==
    ::
        %connect
      ?~  our-address  !!
      :-  =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
          /indexer/amm/batch-order/(scot %ux our-town)
      ::  TODO do we always double scry here or is this good?
      %=    state
          pools
        %~  chain-state  fetch
        [[our now]:bowl u.our-address amm-id our-town]
      ==
    ::
        %start-pool
      ?~  our-address  !!
      ::  given token-a and token-b, fetch our accounts and pool accounts,
      ::  then generate transaction to AMM contract
      =/  our-token-a-account
        %.  [u.our-address meta.token-a.act]
        %~  get-token-account-id  fetch
        [[our now]:bowl u.our-address amm-id our-town]
      ::
      =/  our-token-b-account
        %.  [u.our-address meta.token-b.act]
        %~  get-token-account-id  fetch
        [[our now]:bowl u.our-address amm-id our-town]
      ::
      =/  pool-token-a-account
        %.  [amm-id meta.token-a.act]
        %~  get-token-account-id  fetch
        [[our now]:bowl u.our-address amm-id our-town]
      ::
      =/  pool-token-b-account
        %.  [amm-id meta.token-b.act]
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
          ^-  contract-action
          :+  %start-pool
            :^    meta.token-a.act  
                amount.token-a.act
              pool-token-a-account
            our-token-a-account

          :^    meta.token-b.act
              amount.token-b.act
            pool-token-b-account
          our-token-b-account
      ==
    ::
        %swap
      ?~  our-address  !!
      ?~  pool=(~(get by pools) pool-id.act)  !!
      =/  [payment=token-data receive=token-data]
        ?:  =(metadata.token-a.u.pool meta.payment.act)
          [token-a token-b]:u.pool
        [token-b token-a]:u.pool
      ::
      :_  state  :_  ~
      %+  transaction-poke  our.bowl
      :*  %transaction
          origin=~
          from=u.our-address
          contract=amm-id
          town=our-town
          :-  %noun
          ^-  contract-action
          :*  %swap
              pool-id.act
              :^    metadata.payment
                  amount.payment.act
                pool-account.payment
              our-account.payment
              :^     metadata.receive
                  amount.receive.act
                pool-account.receive
              our-account.receive
          ==
      ==
    ::
        %add-liq
      ?~  our-address  !!
      ?~  pool=(~(get by pools) pool-id.act)  !!
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
          ^-  contract-action
          :*  %add-liq
              pool-id.act
              our-liq-token-account.u.pool
              :^    metadata.token-a
                  amount.token-a.act
                pool-account.token-a
              our-account.token-a
              :^    metadata.token-b
                  amount.token-b.act
                pool-account.token-b
              our-account.token-b
          ==
      ==
    ::
        %remove-liq
      ?~  our-address  !!
      ?~  pool=(~(get by pools) pool-id.act)  !!
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
          ^-  contract-action
          :*  %remove-liq
              pool-id.act
              +.our-liq-token-account.u.pool
              amount.act
              :^    metadata.token-a
                  0
                pool-account.token-a
              our-account.token-a
              :^    metadata.token-b
                  0
                pool-account.token-b
              our-account.token-b
          ==
      ==
    ==
  --
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%testpath ~]
    ~&  >  "got test subscription from {<src.bowl>}"  `this
    ::
      [%pools ~]
    ~&  >  "frontend sub on /pools"  `this
  ==
::
++  on-agent
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
    ?~  our-address  !!
    :-  ~
    %=    this
        pools
      %~  chain-state  fetch
      [[our now]:bowl [u.our-address amm-id our-town]:state]
    ==
  ==
::
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--