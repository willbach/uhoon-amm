/+  *zig-sys-smart
/=  lib  /lib/zig/contracts/uhoon-amm/lib/amm
|_  =cart
++  write
  |=  act=action:lib
  ^-  chick
  ?-    -.act
      %start-pool
    =,  act
    ::  generate liquidity shares
    =/  liq-shares
      ::  burn an infinitesimal amount to prevent shares getting too expensive
      %-  sub  :_  1.000
      -:(sqt (mul liq.token-a liq.token-b))
    ::  determine unique salt for new pool
    =/  salt=@  (cat 3 meta.token-a meta.token-b)
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
              [id.from.cart liq-shares]~
          ==
      ==
    ::  create new pool
    =/  pool-id=id  (fry-rice me.cart me.cart town-id.cart salt)
    =/  =pool:lib   [token-a token-b liq-shares]
    =/  =rice       [salt %pool pool pool-id me.cart me.cart town-id.cart]
    (result ~ [%& rice]~ ~ ~)
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
