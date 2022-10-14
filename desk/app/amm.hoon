/+  *amm, default-agent, dbug
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-0
  ==
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
      =/  info  ~(chain-state fetch our-town-id [our now]:bowl)
      :_  state
      ~[[%give %fact ~[/test] %amm-update !>([%test 'return'])]]
    ::
    ==
  --
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%test ~]
    ~&  >  "got test subscription from {<src.bowl>}"  `this
  ==
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--