::
::  WILL NOT WORK IN THIS DESK, COPY TO ZIG DESK
::
/-  *zig-sequencer
/+  ethereum, merk, smart=zig-sys-smart
/=  fungible  /con/lib/fungible-interface-types
/=  nft  /con/lib/nft-interface-types
/=  publish  /con/lib/publish-interface-types
/=  zigs  /con/lib/zigs-interface-types
/*  fungible-contract  %jam  /con/compiled/fungible/jam
/*  zigs-contract      %jam  /con/compiled/zigs/jam
/*  amm-contract       %jam  /con/compiled/amm/jam
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [rollup-host=@p town-id=@ux private-key=@ux ~] ~]
::  one hundred million testnet zigs, now and forever
=/  testnet-zigs-supply  100.000.000.000.000.000.000.000.000
::
=/  pubkey-1  0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
=/  pubkey-2  0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de
=/  pubkey-3  0x25a8.eb63.a5e7.3111.c173.639b.68ce.091d.d3fc.f139
=/  zigs-1  (hash-data:smart zigs-contract-id:smart pubkey-1 town-id `@`'zigs')
=/  zigs-2  (hash-data:smart zigs-contract-id:smart pubkey-2 town-id `@`'zigs')
=/  zigs-3  (hash-data:smart zigs-contract-id:smart pubkey-3 town-id `@`'zigs')
::
=/  beef-zigs-item
  ^-  item:smart
  :*  %&
      zigs-1
      zigs-contract-id:smart
      pubkey-1
      town-id
      `@`'zigs'
      %account
      [300.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
  ==
=/  dead-zigs-item
  ^-  item:smart
  :*  %&
      zigs-2
      zigs-contract-id:smart
      pubkey-2
      town-id
      `@`'zigs'
      %account
      [200.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
  ==
=/  cafe-zigs-item
  ^-  item:smart
  :*  %&
      zigs-3
      zigs-contract-id:smart
      pubkey-3
      town-id
      `@`'zigs'
      %account
      [100.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
  ==
::
=/  zigs-metadata
  ^-  data:smart
  :*  `@ux`'zigs-metadata'
      zigs-contract-id:smart
      zigs-contract-id:smart
      town-id
      `@`'zigs'
      %token-metadata
      :*  name='UQ| Tokens'
          symbol='ZIG'
          decimals=18
          supply=testnet-zigs-supply
          cap=~
          mintable=%.n
          minters=~
          deployer=0x0
          salt=`@`'zigs'
      ==
  ==
::  zigs.hoon contract
=/  zigs-pact
  ^-  pact:smart
  :*  zigs-contract-id:smart  ::  id
      zigs-contract-id:smart  ::  source
      zigs-contract-id:smart  ::  holder
      town-id                ::  town-id
      [- +]:(cue zigs-contract)
      interface=interface-json:zigs
      types=types-json:zigs
  ==
::  fungible.hoon contract
=/  fungible-pact
  ^-  pact:smart
  =/  code  (cue fungible-contract)
  :*  (hash-pact:smart 0x0 0x0 town-id code)
      0x0          ::  source
      0x0          ::  holder
      town-id      ::  town-id
      [- +]:code
      interface=interface-json:fungible
      types=types-json:fungible
  ==
::  AMM contract
=/  amm-pact
  ^-  pact:smart
  =/  code  (cue amm-contract)
  :*  (hash-pact:smart 0x0 0x0 town-id code)
      0x0          ::  lord
      0x0          ::  holder
      town-id      ::  town-id
      [- +]:code
      interface=~
      types=~
  ==
::
=/  fake-state
  ^-  state
  %+  gas:(bi:merk id:smart item:smart)
    *(merk:merk id:smart item:smart)
  :~  [id.zigs-pact [%| zigs-pact]]
      [id.amm-pact [%| amm-pact]]
      [id.fungible-pact [%| fungible-pact]]
      [zigs-1 beef-zigs-item]
      [zigs-2 dead-zigs-item]
      [zigs-3 cafe-zigs-item]
      [id.zigs-metadata [%& zigs-metadata]]
  ==
::
~&  >  "fungible contract ID: {<id.fungible-pact>}"
~&  >>  "AMM contract ID: {<id.amm-pact>}"
::
:-  %sequencer-town-action
^-  town-action
:*  %init
    rollup-host
    (address-from-prv:key:ethereum private-key)
    private-key
    town-id
    `[fake-state ~]
    [%full-publish ~]
==
