::
::  Tests for AMM contract
::  copy into tests/contracts/ in uqbar-core repo to run
::  make sure to also copy in amm.jam and /con/lib/amm
::
/+  *test, *zig-sys-engine, smart=zig-sys-smart,
    *zig-sequencer, merk
/=  amm-lib  /con/lib/amm
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  amm-contract       %jam  /con/compiled/amm/jam
/*  fungible-contract  %jam  /con/compiled/fungible/jam
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)   ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
++  eng
  %~  engine  engine
  :^    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.n  %.n
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  pubkey-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  caller-1  ^-  caller:smart  [pubkey-1 1 (make-id:zigs-token pubkey-1)]
::
++  zigs-token
  |%
  ++  pact-id  zigs-contract-id:smart
  ++  salt  `@`'zigs'
  ++  metadata
    ^-  item:smart
    :*  %&
        `@ux`'zigs-metadata'
        pact-id
        pact-id
        town-id
        salt
        label=%metadata
        :*  name='ZIG token'
            'ZIG'
            decimals=18
            supply=(price 200)
            cap=~
            mintable=%.n
            minters=~
            0x0
            salt
    ==  ==
  ++  make-id
    |=  holder=id:smart
    ^-  id:smart
    (hash-data:smart pact-id holder town-id salt)
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&
        (make-id holder)
        pact-id
        holder
        town-id
        salt  %account
        [amt ~ id.p:metadata ~]
    ==
  --
::
++  cgy-token
  |%
  ++  pact-id  id:fungible-pact
  ++  salt  `@`'cgy'
  ++  metadata
    ^-  item:smart
    :*  %&
        `@ux`'cgy-metadata'
        pact-id
        pact-id
        town-id
        salt
        label=%metadata
        :*  name='CGY token'
            'CGY'
            decimals=18
            supply=(price 200)
            cap=~
            mintable=%.n
            minters=~
            0x0
            salt
    ==  ==
  ++  make-id
    |=  holder=id:smart
    ^-  id:smart
    (hash-data:smart pact-id holder town-id salt)
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&
        (make-id holder)
        pact-id
        holder
        town-id
        salt  %account
        ::  allowance for amm contract
        [amt [[id:amm-pact amt] ~ ~] id.p:metadata ~]
    ==
  --
::
++  ecs-token
  |%
  ++  pact-id  id:fungible-pact
  ++  salt  `@`'ecs'
  ++  metadata
    ^-  item:smart
    :*  %&
        `@ux`'ecs-metadata'
        pact-id
        pact-id
        town-id
        salt
        label=%metadata
        :*  name='ECS token'
            'ECS'
            decimals=18
            supply=(price 200)
            cap=~
            mintable=%.n
            minters=~
            0x0
            salt
    ==  ==
  ++  make-id
    |=  holder=id:smart
    ^-  id:smart
    (hash-data:smart pact-id holder town-id salt)
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&
        (make-id holder)
        pact-id
        holder
        town-id
        salt  %account
        ::  allowance for amm contract
        [amt [[id:amm-pact amt] ~ ~] id.p:metadata ~]
    ==
  --
::
++  sal-token
  |%
  ++  pact-id  id:fungible-pact
  ++  salt  `@`'sal'
  ++  metadata
    ^-  item:smart
    :*  %&
        `@ux`'sal-metadata'
        pact-id
        pact-id
        town-id
        salt
        label=%metadata
        :*  name='SAL token'
            'SAL'
            decimals=18
            supply=(price 200)
            cap=~
            mintable=%.n
            minters=~
            0x0
            salt
    ==  ==
  ++  make-id
    |=  holder=id:smart
    ^-  id:smart
    (hash-data:smart pact-id holder town-id salt)
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&
        (make-id holder)
        pact-id
        holder
        town-id
        salt  %account
        ::  allowance for amm contract
        [amt [[id:amm-pact amt] ~ ~] id.p:metadata ~]
    ==
  --
::
++  amm-pact
  ^-  pact:smart
  :*  0xcafe  ::  id
      0x0  ::  lord
      0x0  ::  holder
      town-id  ::  town-id
      [- +]:(cue amm-contract)
      interface=~
      types=~
  ==
::
++  fungible-pact
  ^-  pact:smart
  :*  our-fungible-contract:amm-lib  ::  id
      0x0  ::  lord
      0x0  ::  holder
      town-id   ::  town-id
      [- +]:(cue fungible-contract)
      interface=~
      types=~
  ==
::
++  fake-state
  ^-  state
  %+  gas:big  *(merk:merk id:smart item:smart)
  %+  turn
    ^-  (list item:smart)
    :~  %|^amm-pact
        %|^fungible-pact
        metadata:zigs-token
        metadata:cgy-token
        metadata:ecs-token
        metadata:sal-token
        (make-account:zigs-token pubkey-1 (price 25))
        (make-account:cgy-token pubkey-1 (price 25))
        (make-account:ecs-token pubkey-1 (price 5))
        (make-account:sal-token pubkey-1 (price 5))
    ==
  |=(=item:smart [id.p.item item])
::
++  fake-chain
  ^-  chain
  [fake-state *nonces]
::
::  helpers
::
++  price  |=(p=@ud (mul p 1.000.000.000.000.000.000))
::
++  get-pool-id
  |=  [t1=id:smart t2=id:smart]
  ^-  id:smart
  =-  (hash-data:smart id:amm-pact id:amm-pact town-id -)
  ?:  (gth t1 t2)
    (cat 3 t1 t2)
  (cat 3 t2 t1)
::
++  get-lt-metadata-id
  |=  [t1=id:smart t2=id:smart]
  ^-  id:smart
  =-  (hash-data:smart id:fungible-pact id:fungible-pact town-id -)
  %^  cat  3
    ?:  (gth t1 t2)
      (cat 3 t1 t2)
    (cat 3 t2 t1)
  id:amm-pact
::
++  check-pool
  |=  [=state expected-id=id:smart =pool:amm-lib]
  ^-  tang
  =/  pool-item  (got:big state expected-id)
  ?>  ?=(%& -.pool-item)
  %+  expect-eq
    !>(pool)
  !>(noun.p.pool-item)
::
++  assert-balance
  |=  [=state who=address:smart meta-id=id:smart expected=@ud]
  ^-  tang
  =/  md  (got:big state meta-id)
  ?>  ?=(%& -.md)
  =/  it  (hash-data:smart source.p.md who town-id salt.p.md)
  %+  expect-eq
    !>(`expected)
  !>
  ?~  found=(get:big state it)      ~
  ?.  ?=(%& -.u.found)              ~
  ?.  ?=([@ * @ @] noun.p.u.found)  ~
  `-.noun.p.u.found
::
::  begin single-transaction tests
::
++  test-start-pool
  =/  =calldata:smart
    :+  %start-pool
      [id.p:metadata:cgy-token (price 1) (make-id:cgy-token pubkey-1)]
    [id.p:metadata:ecs-token (price 1) (make-id:ecs-token pubkey-1)]
  =/  =shell:smart
    [caller-1 ~ id:amm-pact [1 1.000.000] town-id %0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  ::  ~&  >>  tx
  ::  ~&  %+  murn  ~(tap in p:fake-chain)
  ::      |=  [=id:smart @ =item:smart]
  ::      ?.  ?=(%& -.item)  ~
  ::      `item
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  ~&  >>  output
  =/  new-state  (dif:big (uni:big p:fake-chain modified.output) burned.output)
  ::  expected side effects:
  ::  - new pool grain for CGY/ECS
  ::  - user has 24 CGY tokens, pool has 1
  ::  - user has 4 ECS tokens, pool has 1
  ::  - liquidity token deployed (metadata exists)
  ::  - user has 999.999.999.999.999.000 liquidity token
  =/  metas  [id.p:metadata:cgy-token id.p:metadata:ecs-token]
  =/  pool-id  (get-pool-id metas)
  =/  lt-metadata-id  (get-lt-metadata-id metas)
  =/  expected-pool
    :^    [id.p:metadata:cgy-token id:fungible-pact (price 1)]
        [id.p:metadata:ecs-token id:fungible-pact (price 1)]
      999.999.999.999.999.000
    lt-metadata-id
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.output))
  ::  expected number of side effects (added/altered grains)
    (expect-eq !>(7) !>(~(wyt by modified.output)))
  ::
    (check-pool new-state pool-id expected-pool)
    (assert-balance new-state pubkey-1 id.p:metadata:cgy-token (price 24))
    (assert-balance new-state pubkey-1 id.p:metadata:ecs-token (price 4))
    (assert-balance new-state id:amm-pact id.p:metadata:cgy-token (price 1))
    (assert-balance new-state id:amm-pact id.p:metadata:ecs-token (price 1))
    (assert-balance new-state pubkey-1 lt-metadata-id 999.999.999.999.999.000)
  ==
::
::  ++  test-swap
::    =/  =yolk:smart
::      :*  %swap
::          id.p:ecs-sal-pool
::          payment=[id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
::          ::  the amount here is the minimum amount we'll accept
::          receive=[id.p:sal-token 16.616.666.666.666.666.666 `id.p:amm-sal-account `id.p:sal-account]
::      ==
::    =/  shel=shell:smart
::      [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
::    =/  res=mill-result
::      %+  ~(mill mil miller town-id 1)
::        fake-land
::      `egg:smart`[fake-sig shel yolk]
::    ::
::    =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
::    ::  expected side effects:
::    ::  - pool has (100+50)=150 ecs tokens
::    ::  - pool has 283.383.333.333.333.333.334 sal tokens
::    ::  - caller has (100-50)=50 ecs tokens
::    ::  - caller has 116.616.666.666.666.666.666 sal tokens
::    =/  expected-pool
::      :^    [id.p:ecs-token id:fungible-wheat (price 150)]
::          [id.p:sal-token id:fungible-wheat 283.383.333.333.333.333.334]
::        173.205.080.756.887.728.352
::      id.p:ecs-sal-token
::    ::
::    ;:  weld
::    ::  assert that our call went through
::      (expect-eq !>(%0) !>(errorcode.res))
::      (expect-eq !>(6) !>(~(wyt by p.land.res)))
::    ::
::      (check-pool new-gran id.p:ecs-sal-pool expected-pool)
::      (assert-balance new-gran pubkey-1 id.p:ecs-token (price 50))
::      (assert-balance new-gran pubkey-1 id.p:sal-token 116.616.666.666.666.666.666)
::      (assert-balance new-gran id:amm-wheat id.p:ecs-token (price 150))
::      (assert-balance new-gran id:amm-wheat id.p:sal-token 283.383.333.333.333.333.334)
::    ==
::  ::
::  ++  test-swap-with-slippage
::    =/  =yolk:smart
::      :*  %swap
::          id.p:ecs-sal-pool
::          payment=[id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
::          ::  the amount here is the minimum amount we'll accept
::          receive=[id.p:sal-token (price 16) `id.p:amm-sal-account `id.p:sal-account]
::      ==
::    =/  shel=shell:smart
::      [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
::    =/  res=mill-result
::      %+  ~(mill mil miller town-id 1)
::        fake-land
::      `egg:smart`[fake-sig shel yolk]
::    ::
::    =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
::    ::  expected side effects:
::    ::  - pool has (100+50)=150 ecs tokens
::    ::  - pool has 283.383.333.333.333.333.334 sal tokens
::    ::  - caller has (100-50)=50 ecs tokens
::    ::  - caller has 116.616.666.666.666.666.666 sal tokens
::    =/  expected-pool
::      :^    [id.p:ecs-token id:fungible-wheat (price 150)]
::          [id.p:sal-token id:fungible-wheat 283.383.333.333.333.333.334]
::        173.205.080.756.887.728.352
::      id.p:ecs-sal-token
::    ::
::    ;:  weld
::    ::  assert that our call went through
::      (expect-eq !>(%0) !>(errorcode.res))
::      (expect-eq !>(6) !>(~(wyt by p.land.res)))
::    ::
::      (check-pool new-gran id.p:ecs-sal-pool expected-pool)
::      (assert-balance new-gran pubkey-1 id.p:ecs-token (price 50))
::      (assert-balance new-gran pubkey-1 id.p:sal-token 116.616.666.666.666.666.666)
::      (assert-balance new-gran id:amm-wheat id.p:ecs-token (price 150))
::      (assert-balance new-gran id:amm-wheat id.p:sal-token 283.383.333.333.333.333.334)
::    ==
::  ::
::  ++  test-swap-slip-too-high
::    =/  =yolk:smart
::      :*  %swap
::          id.p:ecs-sal-pool
::          payment=[id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
::          ::  the amount here is the minimum amount we'll accept
::          receive=[id.p:sal-token (price 17) `id.p:amm-sal-account `id.p:sal-account]
::      ==
::    =/  shel=shell:smart
::      [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
::    =/  res=mill-result
::      %+  ~(mill mil miller town-id 1)
::        fake-land
::      `egg:smart`[fake-sig shel yolk]
::    ::
::    =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
::    ::  expected side effects: none
::    ::
::    ;:  weld
::    ::  assert that our call went through
::      (expect-eq !>(%6) !>(errorcode.res))
::      (expect-eq !>(1) !>(~(wyt by p.land.res)))
::    ==
::  ++  test-add-liq
::    =/  =yolk:smart
::      :*  %add-liq
::          id.p:ecs-sal-pool
::          `id.p:ecs-sal-lt-account
::          [id.p:ecs-token (price 10) `id.p:amm-ecs-account `id.p:ecs-account]
::          [id.p:sal-token (price 30) `id.p:amm-sal-account `id.p:sal-account]
::      ==
::    =/  shel=shell:smart
::      [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
::    =/  res=mill-result
::      %+  ~(mill mil miller town-id 1)
::        fake-land
::      `egg:smart`[fake-sig shel yolk]
::    ::
::    ;:  weld
::    ::  assert that our call went through
::      %+  expect-eq
::      !>(%0)  !>(errorcode.res)
::    ==
::  ::
::  ++  test-remove-liq
::    ::  removing liquidity from ECS-SAL pool
::    =/  =yolk:smart
::      :*  %remove-liq
::          id.p:ecs-sal-pool
::          id.p:ecs-sal-lt-account
::          (price 73)
::          [id.p:ecs-token 0 `id.p:amm-ecs-account `id.p:ecs-account]
::          [id.p:sal-token 0 `id.p:amm-sal-account `id.p:sal-account]
::      ==
::    =/  shel=shell:smart
::      [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
::    =/  res=mill-result
::      %+  ~(mill mil miller town-id 1)
::        fake-land
::      `egg:smart`[fake-sig shel yolk]
::    ::
::    ;:  weld
::    ::  assert that our call went through
::      %+  expect-eq
::      !>(%0)  !>(errorcode.res)
::    ==
::  ::
::  ::  begin multi-transaction tests
::  ::
--
