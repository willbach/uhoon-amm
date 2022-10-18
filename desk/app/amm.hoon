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
  `this(state *state-0)
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
      =+  ~(chain-state fetch our-addr our-town-id [our now]:bowl)
      :_  state(pools (~(uni by pools) -))
      ~[[%give %fact ~[/testpath] %amm-update !>([%test 777])]]
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
      ~[[%give %fact ~[/testpath] %amm-update !>([%got-pool state])]]
    ==
  --
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%testpath ~]
    ~&  >  "got test subscription from {<src.bowl>}"  `this
  ==
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--