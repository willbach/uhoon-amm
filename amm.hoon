::  /+  *zig-sys-smart
/=  lib  /lib/zig/contracts/uhoon-amm/lib/amm
|_  =cart
++  write
  |=  act=action:lib
  ^-  chick
  ?-    -.act
      %start-pool
    =,  act
    ::  generate liquidity shares
    =/  liq-shares=@ud
      ::  burn an infinitesimal amount to prevent shares getting too expensive
      %-  sub  :_  1.000
      -:(sqt (mul liq.token-a liq.token-b))
    ::  determine unique salt for new pool
    =/  salt=@
      ?:  (gth meta.token-a meta.token-b)
        (cat 3 meta.token-a meta.token-b)
      (cat 3 meta.token-b meta.token-a)
    ::  take the tokens from caller,
    ::  mint liq token to caller
    =/  [contract-a=id their-acc-a=id our-acc-a=(unit id)]
      (get-take-args:lib meta.token-a me.cart id.from.cart town-id.cart)
    ::
    =/  [contract-b=id their-acc-b=id our-acc-b=(unit id)]
      (get-take-args:lib meta.token-b me.cart id.from.cart town-id.cart)
    ::
    %+  continuation
      :~  :+  contract-a
            town-id.cart
          [%take me.cart liq.token-a their-acc-a our-acc-a]
      ::
          :+  contract-b
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
              [[id.from.cart liq-shares] ~]
          ==
      ==
    ::  create new pool
    =/  pool-id=id  (fry-rice me.cart me.cart town-id.cart salt)
    =/  =pool:lib   [token-a token-b liq-shares]
    =/  =rice       [salt %pool pool pool-id me.cart me.cart town-id.cart]
    (result ~ [%& rice]~ ~ ~)
  ::
      %swap
    =,  act
    =/  pool-rice
      =+  (need (scry-granary pool-id))
      (husk pool:lib - `me.cart `me.cart)
    =/  =pool:lib  data.pool-rice
    =/  fee  ::  fee is 0.3% of swap amount
      %+  mul  trading-fee:lib  ::  30
      (div amount.payment 10.000)
    =/  [swap-input=[meta=id liq=@ud] swap-output=[meta=id liq=@ud]]
      ?:  =(meta.payment meta.token-a.pool)
        [token-a.pool token-b.pool]
      [token-b.pool token-a.pool]
    ::  constant product formula determines price
    ::  p = ra / rb
    =/  price   (div liq.swap-output liq.swap-input)
    =/  amount-received  (div (sub amount.payment fee) price)
    ::  deposit payment and extract output from pool
    =:  liq.swap-input
      (add liq.swap-input amount.payment)
        liq.swap-output
      (sub liq.swap-output amount-received)
    ==
    ::  take the payment from caller,
    ::  give the output to caller
    =/  [take-contract=id their-acc-take=id our-acc-take=(unit id)]
      (get-take-args:lib meta.swap-input me.cart id.from.cart town-id.cart)
    ::
    =/  [give-contract=id their-acc-give=(unit id) our-acc-give=id]
      (get-give-args:lib meta.swap-output me.cart id.from.cart town-id.cart)
    ::
    %+  continuation
      :~  :+  take-contract
            town-id.cart
          [%take me.cart amount.payment their-acc-take our-acc-take]
      ::
          :+  give-contract
            town-id.cart
          [%give id.from.cart amount-received our-acc-give their-acc-give]
      ==
    =/  new-pool
      ?:  =(meta.payment meta.token-a.pool)
          pool(token-a swap-input, token-b swap-output)
        pool(token-a swap-output, token-b swap-input)
    (result [%& pool-rice(data new-pool)]~ ~ ~ ~)
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
