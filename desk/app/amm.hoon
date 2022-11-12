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
  =+  0xdf67.1e3d.95d1.41ef.9152.5164.4b10.811f.53e6.470d.4241.ac9d.1104.ab90.6d18.880a
  %=  this
    our-town     0x0
    our-address  ~
    amm-id       -
    pools        ~
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
        [[our now]:bowl address.act [amm-id our-town]:state]
      ==
    ::
        %connect
      ?~  our-address.state  !!
      :-  =-  [%pass /new-batch %agent [our.bowl %uqbar] %watch -]~
          /indexer/amm/batch-order/(scot %ux our-town.state)
      %=    state
          pools
        %~  chain-state  fetch
        [[our now]:bowl [u.our-address amm-id our-town]:state]
      ==
    ::
        %start-pool
      ?~  our-address.state  !!
      ::  given token-a and token-b, fetch our accounts and pool accounts,
      ::  then generate transaction to AMM contract
      !!
    ::
        %swap
      ?~  our-address.state  !!
      ?~  pool=(~(get by pools.state) pool-id.act)  !!
      !!
    ::
        %add-liq
      ?~  our-address.state  !!
      ?~  pool=(~(get by pools.state) pool-id.act)  !!
      !!
    ::
        %remove-liq
      ?~  our-address.state  !!
      ?~  pool=(~(get by pools.state) pool-id.act)  !!
      !!
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