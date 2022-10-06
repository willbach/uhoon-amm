/+  *zig-sys-smart
/=  lib  /lib/zig/contracts/lib/amm
|_  =cart
++  write
  |=  act=action:lib
  ^-  chick
  ?-    -.act
      %start-pool
    =,  act
    =/  liq-shares
      %-  sub  :_  1.000
      -:(sqt (mul liq.token-a liq.token-b))
    =/  salt=@  (cat 3 meta.token-a meta.token-b)
    =/  pool-id=id  (fry-rice me.cart me.cart town-id.cart salt)
    =/  =pool:lib
      :+  token-a
        token-b
      liq-shares
    ::  create pool grain,
    ::  take the tokens from caller,
    ::  mint liq token to caller
    =/  metadata-a=rice
      =-  ?>  ?=(%& -.m)  +.m
      m=(need (scry-granary meta.token-a))
    =/  token-contract-a
      lord.metadata-a
    =/  their-acc-a=id
      (fry-rice lord.metadata-a id.from.cart town-id.cart salt.metadata-a)
    =/  our-acc-a=(unit id)
      =-  ?~(found=(scry-granary -) ~ `id.p.u.found)
      (fry-rice lord.metadata-a me.cart town-id.cart salt.metadata-a)
    ::
    =/  metadata-b=rice
      =-  ?>  ?=(%& -.m)  +.m
      m=(need (scry-granary meta.token-b))
    =/  token-contract-b
      lord.metadata-b
    =/  their-acc-b=id
      (fry-rice lord.metadata-b id.from.cart town-id.cart salt.metadata-b)
    =/  our-acc-b=(unit id)
      =-  ?~(found=(scry-granary -) ~ `id.p.u.found)
      (fry-rice lord.metadata-b me.cart town-id.cart salt.metadata-b)
    ::
    %+  continuation
      :~  :+  token-contract-a
            town-id.cart
          [%take me.cart liq.token-a their-acc-a our-acc-a]
      ::
          :+  token-contract-b
            town-id.cart
          [%take me.cart liq.token-b their-acc-b our-acc-b]
      ::
          :+  our-fungible-contract:lib
            town-id.cart
          :*  %deploy
              name='Liquity Token: xx'
              symbol='LT'
              salt
              ~
              minters=[me.cart ~ ~]
              [id.from.cart liq-shares]~
          ==
      ==
    (result ~ [%& salt %pool pool pool-id me.cart me.cart town-id.cart]~ ~ ~)
  ::
      %swap
    !!
  ::
      %add-liq
    !!
  ::
      %remove-liq
    !!
  ==
++  read
  |_  =path
  ++  json
    ~
  ++  noun
    ~
  --
--
::  Uqbar AMM notes
::
::  - emulate structure of Uniswap v2
::
::  Actions
::
::  - start-pool
::  Initial pool generation, makes a new grain containing pool info and sets initial price curve
::
::  - swap
::  User trades token pair in a given pool
::
::  - add-liquidity
::  User adds tokens to a specified pool, receives liquidity token
::
::  - remove-liquidity
::  User exchanges liquidity token for their share of pool
::
::
::  First version should use %take action in fungible standard — user must set approval before any of above actions
::
::  In future, can upgrade to use %push action that sends tokens and calls contract in same txn
