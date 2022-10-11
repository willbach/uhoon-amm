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
    =/  salt=@  (get-pool-salt:lib meta.token-a meta.token-b)
    ::  take the tokens from caller,
    ::  mint liq token to caller
    =/  liq-token-meta-id
      (fry-rice our-fungible-contract:lib our-fungible-contract:lib town-id.cart salt)
    ::
    %+  continuation
      :~  :+  contract.token-a
            town-id.cart
          :*  %take
              me.cart
              liq.token-a
              caller-account.token-a
              pool-account.token-a
          ==
      ::
          :+  contract.token-b
            town-id.cart
          :*  %take
              me.cart
              liq.token-b
              caller-account.token-b
              pool-account.token-b
          ==
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
    =/  =pool:lib   [token-a token-b liq-shares liq-token-meta-id]
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
    ::  determine allowed output w/ slippage
    ::  TODO also set max? probably not needed
    ?>  (gte amount-received min-output)
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
    =,  act
    =/  pool-rice
      =+  (need (scry-granary pool-id))
      (husk pool:lib - `me.cart `me.cart)
    =/  =pool:lib  data.pool-rice
    ::  assert that added liquidity is valid for pool
    ?>  ?&  =(meta.token-a.pool meta.token-a)
            =(meta.token-b.pool meta.token-b)
        ==
    ::  calculate liquidity token mint amount
    =/  liq-to-mint
      %+  add
        %+  mul  liq-shares.pool
        (div liq.token-a liq.token-a.pool)
      %+  mul  liq-shares.pool
      (div liq.token-b liq.token-b.pool)
    ::  add token-a and token-b to pool,
    ::  and mint liquidity tokens to caller
    =:  liq.token-a.pool
      (add liq.token-a.pool liq.token-a)
        liq.token-b.pool
      (add liq.token-b.pool liq.token-b)
    ==
    ::
    =/  their-lt-account=(unit id)
      =-  ?~(found=(scry-granary -) ~ `id.p.u.found)
      (fry-rice our-fungible-contract:lib id.from.cart town-id.cart salt.pool-rice)
    %+  continuation
      :~  :+  contract.token-a
            town-id.cart
          :*  %take
              me.cart
              liq.token-a
              caller-account.token-a
              pool-account.token-a
          ==
      ::
          :+  contract.token-b
            town-id.cart
          :*  %take
              me.cart
              liq.token-b
              caller-account.token-b
              pool-account.token-b
          ==
      ::
          :+  our-fungible-contract:lib
            town-id.cart
          :*  %mint
              token=liq-token-meta.pool
              [[to=id.from.cart their-lt-account amount=liq-to-mint] ~]
          ==
      ==
    (result [%& pool-rice(data pool)]~ ~ ~ ~)
  ::
      %remove-liq
    =/  pool-rice
      =+  (need (scry-granary pool-id.act))
      (husk pool:lib - `me.cart `me.cart)
    =/  =pool:lib  data.pool-rice
    ::  assert that liquidity shares match the pool
    =/  pool-salt=@  (get-pool-salt:lib meta.token-a.pool meta.token-b.pool)
    ?>  =-  =(- liq-shares-account.act)
        %-  fry-rice
        [our-fungible-contract:lib id.from.cart town-id.cart pool-salt]
    ::  calculate reward in each token
    ::  tokenWithdrawn = (total * (liquidityBurned * 10^18) / (totalLiquidity)) / 10^18
    =/  token-a-withdraw
      (div (mul liq.token-a.pool (div (mul amount.act dec-18:lib) liq-shares.pool)) dec-18:lib)
    =/  token-b-withdraw
      (div (mul liq.token-b.pool (div (mul amount.act dec-18:lib) liq-shares.pool)) dec-18:lib)
    ::  modify pool with new amounts
    =:  liq.token-a.pool
      (sub liq.token-a.pool token-a-withdraw)
        liq.token-b.pool
      (sub liq.token-b.pool token-b-withdraw)
        liq-shares.pool
      (sub liq-shares.pool amount.act)
    ==
    ::  get information for token %gives
    =/  [give-contract-a=id their-acc-give-a=(unit id) our-acc-give-a=id]
      (get-give-args:lib meta.token-a.pool me.cart id.from.cart town-id.cart)
    =/  [give-contract-b=id their-acc-give-b=(unit id) our-acc-give-b=id]
      (get-give-args:lib meta.token-b.pool me.cart id.from.cart town-id.cart)
    ::  execute %take of liquidity token and %gives for tokens a&b
    ::  we always %burn our liq token account, so we will never have one
    %+  continuation
      :~  :+  our-fungible-contract:lib
            town-id.cart
          [%take me.cart amount.act liq-shares-account.act ~]
      ::
          :+  0x0
            town-id.cart
          =-  [%burn - 0x0]
          (fry-rice our-fungible-contract:lib me.cart town-id.cart pool-salt)
      ::
          :+  give-contract-a
            town-id.cart
          [%give id.from.cart token-a-withdraw our-acc-give-a their-acc-give-a]
      ::
          :+  give-contract-b
            town-id.cart
          [%give id.from.cart token-b-withdraw our-acc-give-b their-acc-give-b]
      ==
    (result [%& pool-rice(data pool)]~ ~ ~ ~)
  ==
++  read
  |_  =path
  ++  json
    ~
  ++  noun
    ~
  --
--
