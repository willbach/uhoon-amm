/+  *zig-sys-smart
/=  lib  /con/lib/amm
|_  =context
++  write
  |=  act=action:lib
  ^-  (quip call diff)
  ?-    -.act
      %start-pool
    =,  act
    ::  generate liquidity shares
    =/  liq-shares=@ud
      ::  burn an infinitesimal amount to prevent
      ::  shares from getting too expensive
      %-  sub  :_  1.000
      -:(sqt (mul amount.token-a amount.token-b))
    ::  determine unique salt for new pool
    =/  salt=@  (get-pool-salt:lib meta.token-a meta.token-b)
    ::  find contract IDs for the two tokens
    ::  get token symbols for liquidity token name
    =/  a  (need (scry-state meta.token-a))
    ?>  ?=(%& -.a)
    =/  contract-a=id  source.p.a
    =/  symbol-a=@t  symbol:;;([@t symbol=@t *] noun.p.a)
    =/  b  (need (scry-state meta.token-b))
    ?>  ?=(%& -.b)
    =/  contract-b=id  source.p.b
    =/  symbol-b=@t  symbol:;;([@t symbol=@t *] noun.p.b)
    ::  take the tokens from caller,
    ::  mint liq token to caller
    =/  liq-token-meta-id
      %-  hash-data
      :^    our-fungible-contract:lib
          our-fungible-contract:lib
        town.context
      ::  fungible contract appends caller ID (our ID) to salt
      (cat 3 salt this.context)
    ::  create new pool
    =/  pool-id=id  (hash-data this.context this.context town.context salt)
    =/  =pool:lib
      :^    [meta.token-a contract-a amount.token-a]
          [meta.token-b contract-b amount.token-b]
        liq-shares
      liq-token-meta-id
    =/  =data  [pool-id this.context this.context town.context salt %pool pool]
    ::
    :_  (result ~ [%& data]~ ~ ~)
    :~  :+  contract-a
          town.context
        :*  %take
            this.context
            amount.token-a
            from-account.token-a
        ==
    ::
        :+  contract-b
          town.context
        :*  %take
            this.context
            amount.token-b
            from-account.token-b
        ==
    ::
        :+  our-fungible-contract:lib
          town.context
        :*  %deploy
            :((cury cat 3) 'Liquity Token: ' symbol-a '-' symbol-b)
            :((cury cat 3) 'LT' symbol-a symbol-b)
            salt
            ~
            minters=[this.context ~ ~]
            [[id.caller.context liq-shares] ~]
        ==
    ==
  ::
      %swap
    =,  act
    =/  pool-data
      =+  (need (scry-state pool-id))
      (husk pool:lib - `this.context `this.context)
    =/  =pool:lib  noun.pool-data
    =/  fee  ::  fee is 0.3% of swap amount
      %+  mul  trading-fee:lib  ::  30
      (div amount.payment 10.000)
    ::  =/  protocol-fee  (div fee 10)  ::  10% of total fee
    ::  determine which token is being given, and which received
    =+  ^-  $:  swap-input=[meta=id contract=id liq=@ud]
                swap-output=[meta=id contract=id liq=@ud]
            ==
      ?:  =(meta.payment meta.token-a.pool)
        [token-a.pool token-b.pool]
      [token-b.pool token-a.pool]
    ::  assert swap is correct for this pool
    ?>  ?&  =(meta.payment meta.swap-input)
            =(meta.receive meta.swap-output)
        ==
    ::  constant product formula determines price
    ::  p = ra / rb
    =/  price  (div (mul liq.swap-output dec-18:lib) liq.swap-input)
    =/  amount-received  (div (mul (sub amount.payment fee) dec-18:lib) price)
    ::  determine allowed output w/ slippage
    ::  TODO also set max? probably not needed
    ?>  (gte amount-received amount.receive)
    ::  deposit payment and extract output from pool
    =:  liq.swap-input   (add liq.swap-input amount.payment)
        liq.swap-output  (sub liq.swap-output amount-received)
    ==
    ::  take the payment from caller,
    ::  give the output to caller
    ::
    =.  noun.pool-data
      ?:  =(meta.payment meta.token-a.pool)
        pool(token-a swap-input, token-b swap-output)
      pool(token-a swap-output, token-b swap-input)
    :_  (result [%& pool-data]~ ~ ~ ~)
    :~  :+  contract.swap-input
          town.context
        :*  %take
            this.context
            amount.payment
            from-account.payment  ::  caller's token account
        ==
    ::
        :+  contract.swap-output
          town.context
        :*  %give
            id.caller.context
            amount-received
            from-account.receive  ::  pool's token account
        ==
    ==
  ::
      %add-liq
    =,  act
    =/  pool-data
      =+  (need (scry-state pool-id))
      (husk pool:lib - `this.context `this.context)
    =/  =pool:lib  noun.pool-data
    ::  assert that added liquidity is valid for pool
    ?>  ?&  =(meta.token-a.pool meta.token-a)
            =(meta.token-b.pool meta.token-b)
        ==
    ::  calculate liquidity token mint amount
    =/  liq-to-mint
      %-  div  :_  dec-18:lib
      %+  add
        %+  mul  liq-shares.pool
        (div (mul amount.token-a dec-18:lib) liq.token-a.pool)
      %+  mul  liq-shares.pool
      (div (mul amount.token-b dec-18:lib) liq.token-b.pool)
    ::  add token-a and token-b to pool,
    ::  and mint liquidity tokens to caller
    =:  liq.token-a.pool
      (add liq.token-a.pool amount.token-a)
        liq.token-b.pool
      (add liq.token-b.pool amount.token-b)
        liq-shares.pool
      (add liq-to-mint liq-shares.pool)
    ==
    ::
    :_  (result [%&^pool-data(noun pool) ~] ~ ~ ~)
    :~  :+  contract.token-a.pool
          town.context
        :*  %take
            this.context
            amount.token-a
            from-account.token-a
        ==
    ::
        :+  contract.token-b.pool
          town.context
        :*  %take
            this.context
            amount.token-b
            from-account.token-b
        ==
    ::
        :+  our-fungible-contract:lib
          town.context
        :*  %mint
            token=liq-token-meta.pool
            [[to=id.caller.context amount=liq-to-mint] ~]
        ==
    ==
  ::
      %remove-liq
    =,  act
    =/  pool-data
      =+  (need (scry-state pool-id.act))
      (husk pool:lib - `this.context `this.context)
    =/  =pool:lib  noun.pool-data
    ::  assert that liquidity shares match the pool
    =/  liq-shares-item
      =+  (need (scry-state liq-shares-account.act))
      (husk token-account:lib - `our-fungible-contract:lib `id.caller.context)
    ?>  =(metadata.noun.liq-shares-item liq-token-meta.pool)
    ::  calculate reward in each token
    ::  (total * (liquidityBurned * 10^18) / (totalLiquidity)) / 10^18
    =/  token-a-withdraw
      %-  div  :_  dec-18:lib
      (mul liq.token-a.pool (div (mul amount.act dec-18:lib) liq-shares.pool))
    =/  token-b-withdraw
      %-  div  :_  dec-18:lib
      (mul liq.token-b.pool (div (mul amount.act dec-18:lib) liq-shares.pool))
    ::  modify pool with new amounts
    =:  liq.token-a.pool
      (sub liq.token-a.pool token-a-withdraw)
        liq.token-b.pool
      (sub liq.token-b.pool token-b-withdraw)
        liq-shares.pool
      (sub liq-shares.pool amount.act)
    ==
    ::  execute %take of liquidity token and %gives for tokens a&b
    :_  (result [%& pool-data(noun pool)]~ ~ ~ ~)
    :~  :+  our-fungible-contract:lib
          town.context
        :*  %take
            this.context
            amount.act
            liq-shares-account.act
        ==
    ::
        :+  contract.token-a.pool
          town.context
        :*  %give
            id.caller.context
            token-a-withdraw
            from-account.token-a  ::  pool token account
        ==
    ::
        :+  contract.token-b.pool
          town.context
        :*  %give
            id.caller.context
            token-b-withdraw
            from-account.token-b  ::  pool token account
        ==
    ==
  ::
      %on-push
    ::  we only support %swap and %remove-liq
    ::  here, because these are the only two actions
    ::  that only require ONE token approval.
    =/  calldata  ;;(action:lib calldata.act)
    ?>  ?+  -.calldata  %.n
          %swap        =(amount.act amount.payment.calldata)
          %remove-liq  =(amount.act amount.calldata)
        ==
    %=  $
      act  calldata
      id.caller.context  from.act
    ==
  ::
  ::    %offload
  ::  ::  burn treasury tokens to receive share
  ::  =,  act
  ::  =/  treasury-meta  (need (scry-state meta.treasury-token))
  ::  ?>  ?&  ?=(%& -.treasury-meta)
  ::          =(source.p.treasury-meta our-fungible-contract:lib)
  ::          =(meta.treasury-token treasury-token-metadata:lib)
  ::          ::  hacky way to read token metadata
  ::          ?=([@ @ @ supply=@ud ^ @ ^ deployer=id @] noun.p.treasury-meta)
  ::          =(deployer.noun.p.treasury-meta treasury-token-deployer:lib)
  ::      ==
  ::  :_  (result ~ ~ ~ ~)
  ::  %-  snoc
  ::  :_  :+  our-fungible-contract:lib
  ::        town.context
  ::      :*  %take
  ::          this.context
  ::          amount.treasury-token
  ::          (need caller-account.treasury-token)
  ::          pool-account.treasury-token
  ::      ==
  ::  %+  turn  treasury-accounts
  ::  |=  =token-args:lib
  ::  ^-  call
  ::  =/  token-contract  source.p:(need (scry-state meta.token-args))
  ::  =/  token-account  (need (scry-state (need pool-account.token-args)))
  ::  ?>  ?&  ?=(%& -.token-account)
  ::          ::  hacky way to read token account
  ::          ?=([reserves=@ud ^ meta=id ^] noun.p.token-account)
  ::          =(meta.noun.p.token-account meta.token-args)
  ::      ==
  ::  :+  token-contract
  ::    this.context
  ::  :*  %give
  ::      id.caller.context
  ::      ::  if treasury token supply = 1 million, and user has 1 treasury token,
  ::      ::  they are entitled to 1 one millionth of each treasury account
  ::      ::  formula: divide (treasury account)*10^18 by (treasury token supply),
  ::      ::  then multiply result by (amount of user treasury tokens), then divide by 10^18
  ::      %+  div
  ::        %+  mul
  ::          %+  div  reserves.noun.p.token-account
  ::          supply.noun.p.treasury-meta
  ::        amount.treasury-token
  ::      dec-18:lib
  ::      (need pool-account.token-args)
  ::      caller-account.token-args
  ::  ==
  ==
++  read
  |_  =path
  ++  json
    ~
  ++  noun
    ~
  --
--
