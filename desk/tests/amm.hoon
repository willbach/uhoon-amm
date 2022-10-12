::
::  Test of AMM contract
::
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun  %noun  /lib/zig/compiled/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/compiled/hash-cache/noun
/*  amm-contract    %noun  /lib/zig/contracts/uhoon-amm/desk/compiled/amm/noun
/*  fungible-contract  %noun  /lib/zig/compiled/fungible/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart grain:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
+$  mill-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  pubkey-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  caller-1  ^-  caller:smart  [pubkey-1 1 id.p:account-1:zigs]
::
++  zigs
  |%
  ++  account-1
    ^-  grain:smart
    :*  %&
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata']
        (fry-rice:smart zigs-wheat-id:smart pubkey-1 town-id `@`'zigs')
        zigs-wheat-id:smart
        pubkey-1
        town-id
    ==
  --
::
++  amm-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] amm-contract)))
      interface=~
      types=~
      0xcafe  ::  id
      0xcafe  ::  lord
      0xcafe  ::  holder
      town-id  ::  town-id
  ==
::
++  fungible-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] fungible-contract)))
      interface=~
      types=~
      0x1234  ::  id
      0x1234  ::  lord
      0x1234  ::  holder
      town-id   ::  town-id
  ==
::
++  cgy-token
  ^-  grain:smart
  =+  deployer=0x0
  =+  salt=`@`'cgy-token'
  :*  %&  salt  %metadata
      :*  name='CGY Token'
          'CGY'
          decimals=18
          supply=(price 100)
          cap=~
          mintable=%.n
          minters=~
          deployer
          salt
      ==
      `@ux`'cgy-metadata'
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
++  ecs-token
  ^-  grain:smart
  =+  deployer=0x0
  =+  salt=`@`'ecs-token'
  :*  %&  salt  %metadata
      :*  name='ECS Token'
          'ECS'
          decimals=18
          supply=(price 200)
          cap=~
          mintable=%.n
          minters=~
          deployer
          salt
      ==
      `@ux`'ecs-metadata'
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
++  sal-token
  ^-  grain:smart
  =+  deployer=0x0
  =+  salt=`@`'sal-token'
  :*  %&  salt  %metadata
      :*  name='SAL Token'
          'SAL'
          decimals=18
          supply=(price 400)
          cap=~
          mintable=%.n
          minters=~
          deployer
          salt
      ==
      `@ux`'sal-metadata'
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
++  ecs-sal-token
  ^-  grain:smart
  =+  salt=`@`(cat 3 `@`'ecs-metadata' `@`'sal-metadata')
  :*  %&  salt  %metadata
      :*  name='Liquidity Token: xx'
          'LT'
          decimals=18
          supply=173.205.080.756.887.728.352
          cap=~
          mintable=%.y
          minters=(make-pset:smart ~[id:amm-wheat])
          deployer=id:amm-wheat
          salt
      ==
      (fry-rice:smart id:fungible-wheat id:fungible-wheat town-id salt)
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
::
++  make-fun-account
  |=  [holder=id:smart amt=@ud meta=grain:smart allowances=(pmap:smart address:smart @ud)]
  ::  meta - metadata of the fungible account. defaults to `@ux`'simple' unless provided
  ^-  grain:smart
  ?>  ?=(%& -.meta)
  =/  id  (fry-rice:smart id:fungible-wheat holder town-id salt.p.meta)
  :*  %&  salt.p.meta  %account
      [amt allowances id.p:meta 0]
      id
      id:fungible-wheat
      holder
      town-id
  ==
::
++  cgy-account
  %:  make-fun-account
      pubkey-1
      (price 100)
      cgy-token
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:amm-wheat (price 100)]])
  ==
::
++  ecs-account
  %:  make-fun-account
      pubkey-1
      (price 100)
      ecs-token
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:amm-wheat (price 100)]])
  ==
::
++  sal-account
  %:  make-fun-account
      pubkey-1
      (price 100)
      sal-token
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:amm-wheat (price 100)]])
  ==
::
++  ecs-sal-lt-account
  %:  make-fun-account
      pubkey-1
      173.205.080.756.887.728.352
      ecs-sal-token
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:amm-wheat 173.205.080.756.887.728.352]])
  ==
::
::  these are held by amm contract
::
++  amm-ecs-account
  %:  make-fun-account
      id:amm-wheat
      (price 100)
      ecs-token
      ~
  ==
++  amm-sal-account
  %:  make-fun-account
      id:amm-wheat
      (price 300)
      sal-token
      ~
  ==
::
++  ecs-sal-pool
  ^-  grain:smart
  =/  salt  (cat 3 `@`'ecs-metadata' `@`'sal-metadata')
  :*  %&  salt  %pool
      :*  [`@ux`'ecs-metadata' id:fungible-wheat (price 100)]
          [`@ux`'sal-metadata' id:fungible-wheat (price 300)]
          liq-shares=173.205.080.756.887.728.352
          liq-token-meta=id.p:ecs-sal-token
      ==
      (fry-rice:smart id:amm-wheat id:amm-wheat town-id salt)
      id:amm-wheat
      id:amm-wheat
      town-id
  ==
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart grain:smart)
  :~  [id:amm-wheat [%| amm-wheat]]
      [id:fungible-wheat [%| fungible-wheat]]
      [id.p:account-1:zigs account-1:zigs]
      [id.p:cgy-token cgy-token]
      [id.p:ecs-token ecs-token]
      [id.p:sal-token sal-token]
      [id.p:ecs-sal-token ecs-sal-token]
      [id.p:cgy-account cgy-account]
      [id.p:ecs-account ecs-account]
      [id.p:sal-account sal-account]
      [id.p:ecs-sal-lt-account ecs-sal-lt-account]
      [id.p:amm-ecs-account amm-ecs-account]
      [id.p:amm-sal-account amm-sal-account]
      [id.p:ecs-sal-pool ecs-sal-pool]
  ==
++  fake-land
  ^-  land
  [fake-granary *populace]
::
::  helpers
::
++  price  |=(p=@ud (mul p 1.000.000.000.000.000.000))
::
++  get-pool-id
  |=  [t1=id:smart t2=id:smart]
  ^-  id:smart
  =-  (fry-rice:smart id:amm-wheat id:amm-wheat town-id -)
  ?:  (gth t1 t2)
    (cat 3 t1 t2)
  (cat 3 t2 t1)
::
++  get-lt-metadata-id
  |=  [t1=id:smart t2=id:smart]
  ^-  id:smart
  =-  (fry-rice:smart id:fungible-wheat id:fungible-wheat town-id -)
  ?:  (gth t1 t2)
    (cat 3 t1 t2)
  (cat 3 t2 t1)
::
+$  pool
  $:  token-a=[meta=id:smart contract=id:smart liq=@ud]  ::  id of metadata grain
      token-b=[meta=id:smart contract=id:smart liq=@ud]
      liq-shares=@ud
      liq-token-meta=id:smart
  ==
::
++  check-pool
  |=  [=granary expected-id=id:smart =pool]
  ^-  tang
  =/  pool-grain  (got:big granary expected-id)
  ?>  ?=(%& -.pool-grain)
  %+  expect-eq
    !>(pool)
  !>(data.p.pool-grain)
::
++  assert-balance
  |=  [=granary who=address:smart meta-id=id:smart expected=@ud]
  ^-  tang
  =/  md  (got:big granary meta-id)
  ?>  ?=(%& -.md)
  =/  it  (fry-rice:smart lord.p.md who town-id salt.p.md)
  %+  expect-eq
    !>(`expected)
  !>
  ?~  found=(get:big granary it)    ~
  ?.  ?=(%& -.u.found)              ~
  ?.  ?=([@ * @ @] data.p.u.found)  ~
  `-.data.p.u.found
::
::  begin single-transaction tests
::
++  test-start-pool
  =/  =yolk:smart
    :+  %start-pool
      [id.p:cgy-token (price 100) ~ `id.p:cgy-account]
    [id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
  ::
  ::  expected side effects:
  ::  - new pool grain for CGY/ECS
  ::  - user has 0 CGY tokens, pool has 100
  ::  - user has 50 ECS tokens, pool has 150 (it starts with 100)
  ::  - liquidity token deployed (metadata exists)
  ::  - user has 70.7106781187 liquidity tokens
  =/  pool-id  (get-pool-id id.p:cgy-token id.p:ecs-token)
  =/  lt-metadata-id  (get-lt-metadata-id id.p:cgy-token id.p:ecs-token)
  =/  expected-pool
    :^    [id.p:cgy-token id:fungible-wheat (price 100)]
        [id.p:ecs-token id:fungible-wheat (price 50)]
      70.710.678.118.654.751.440
    lt-metadata-id
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.res))
  ::  expected number of side effects (added/altered grains)
    (expect-eq !>(8) !>(~(wyt by p.land.res)))
  ::
    (check-pool new-gran pool-id expected-pool)
    (assert-balance new-gran pubkey-1 id.p:cgy-token 0)
    (assert-balance new-gran pubkey-1 id.p:ecs-token (price 50))
    (assert-balance new-gran id:amm-wheat id.p:cgy-token (price 100))
    (assert-balance new-gran id:amm-wheat id.p:ecs-token (price 150))
    (assert-balance new-gran pubkey-1 lt-metadata-id 70.710.678.118.654.751.440)
  ==
::
++  test-swap
  =/  =yolk:smart
    :*  %swap
        id.p:ecs-sal-pool
        payment=[id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
        ::  the amount here is the minimum amount we'll accept
        receive=[id.p:sal-token 16.616.666.666.666.666.666 `id.p:amm-sal-account `id.p:sal-account]
    ==
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
  ::  expected side effects:
  ::  - pool has (100+50)=150 ecs tokens
  ::  - pool has 283.383.333.333.333.333.334 sal tokens
  ::  - caller has (100-50)=50 ecs tokens
  ::  - caller has 116.616.666.666.666.666.666 sal tokens
  =/  expected-pool
    :^    [id.p:ecs-token id:fungible-wheat (price 150)]
        [id.p:sal-token id:fungible-wheat 283.383.333.333.333.333.334]
      173.205.080.756.887.728.352
    id.p:ecs-sal-token
  ::
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.res))
    (expect-eq !>(6) !>(~(wyt by p.land.res)))
  ::
    (check-pool new-gran id.p:ecs-sal-pool expected-pool)
    (assert-balance new-gran pubkey-1 id.p:ecs-token (price 50))
    (assert-balance new-gran pubkey-1 id.p:sal-token 116.616.666.666.666.666.666)
    (assert-balance new-gran id:amm-wheat id.p:ecs-token (price 150))
    (assert-balance new-gran id:amm-wheat id.p:sal-token 283.383.333.333.333.333.334)
  ==
::
++  test-swap-with-slippage
  =/  =yolk:smart
    :*  %swap
        id.p:ecs-sal-pool
        payment=[id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
        ::  the amount here is the minimum amount we'll accept
        receive=[id.p:sal-token (price 16) `id.p:amm-sal-account `id.p:sal-account]
    ==
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
  ::  expected side effects:
  ::  - pool has (100+50)=150 ecs tokens
  ::  - pool has 283.383.333.333.333.333.334 sal tokens
  ::  - caller has (100-50)=50 ecs tokens
  ::  - caller has 116.616.666.666.666.666.666 sal tokens
  =/  expected-pool
    :^    [id.p:ecs-token id:fungible-wheat (price 150)]
        [id.p:sal-token id:fungible-wheat 283.383.333.333.333.333.334]
      173.205.080.756.887.728.352
    id.p:ecs-sal-token
  ::
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.res))
    (expect-eq !>(6) !>(~(wyt by p.land.res)))
  ::
    (check-pool new-gran id.p:ecs-sal-pool expected-pool)
    (assert-balance new-gran pubkey-1 id.p:ecs-token (price 50))
    (assert-balance new-gran pubkey-1 id.p:sal-token 116.616.666.666.666.666.666)
    (assert-balance new-gran id:amm-wheat id.p:ecs-token (price 150))
    (assert-balance new-gran id:amm-wheat id.p:sal-token 283.383.333.333.333.333.334)
  ==
::
++  test-swap-slip-too-high
  =/  =yolk:smart
    :*  %swap
        id.p:ecs-sal-pool
        payment=[id.p:ecs-token (price 50) `id.p:amm-ecs-account `id.p:ecs-account]
        ::  the amount here is the minimum amount we'll accept
        receive=[id.p:sal-token (price 17) `id.p:amm-sal-account `id.p:sal-account]
    ==
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  =/  new-gran  (dif:big (uni:big p:fake-land p.land.res) burned.res)
  ::  expected side effects: none
  ::
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%6) !>(errorcode.res))
    (expect-eq !>(1) !>(~(wyt by p.land.res)))
  ==
++  test-add-liq
  =/  =yolk:smart
    :*  %add-liq
        id.p:ecs-sal-pool
        `id.p:ecs-sal-lt-account
        [id.p:ecs-token (price 10) `id.p:amm-ecs-account `id.p:ecs-account]
        [id.p:sal-token (price 30) `id.p:amm-sal-account `id.p:sal-account]
    ==
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
::
++  test-remove-liq
  ::  removing liquidity from ECS-SAL pool
  =/  =yolk:smart
    :*  %remove-liq
        id.p:ecs-sal-pool
        id.p:ecs-sal-lt-account
        (price 73)
        [id.p:ecs-token 0 `id.p:amm-ecs-account `id.p:ecs-account]
        [id.p:sal-token 0 `id.p:amm-sal-account `id.p:sal-account]
    ==
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
::
::  begin multi-transaction tests
::
--
