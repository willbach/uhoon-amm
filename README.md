# uhoon-amm
AMM contract for Uqbar in the style of Uniswap V2

quick bug/improvement depository:
- fungible token allowance under total balance crashes
- strip empty spaces before&after search bar hash
- 

These commands assume:

- ZIGS contract `0x74.6361.7274.6e6f.632d.7367.697a`

- fungible contract ID `0x7abb.3cfe.50ef.afec.95b7.aa21.4962.e859.87a0.b22b.ec9b.3812.69d3.296b.24e1.d72a`

- AMM contract ID `0xbd1.f4a1.b3eb.85b4.157f.bff2.3945.3ff8.8104.b8ac.425d.74f5.a799.d159.54a5.dc8b`

- SQUID token `0xe3e.17c6.36d1.f0a7.d037.9553.9d60.f44c.8a8b.d57a.f800.bab2.334e.60a2.3cda.4d17`

- SQUID metadata item `0xd19.a57e.01f2.473b.026f.506b.16a5.ce9b.2580.96fd.07a2.7e59.461a.7386.f3d4.2b56`

note the hardcoded our-fungible-contract in con/lib/amm


We'll first use the wallet dojo CLI to deploy a new token and set some allowances such that the AMM contract can pull from our accounts:


```
Deploy a token, `SQUID`:
```
:uqbar &wallet-poke [%transaction ~ from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x7abb.3cfe.50ef.afec.95b7.aa21.4962.e859.87a0.b22b.ec9b.3812.69d3.296b.24e1.d72a town=0x0 action=[%noun [%deploy 'squid token' 'SQUID' 999 ~ [0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 0 0] ~[[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 300.000.000.000.000.000.000]]]]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0x5c6f.32b8.c4d1.447e.0d30.5ce2.f46c.1625 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

:: todo, interface (/types)
Deploy the AMM: 
```
these 2 steps are necessary if you modify the contract before deploying, otherwise jam file will exist in /con/compiled already
  .amm/jam +zig!compile /=amm=/con/amm/hoon
  copy the amm.jam file from .urb/put to /con/compiled
  |commit %amm


=contract-path /=amm=/con/compiled/amm/jam
=contract-jam .^(@ %cx contract-path)
=contract [- +]:(cue contract-jam)

:uqbar &wallet-poke [%transaction ~ from=[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70] contract=0x1111.1111 town=0x0 action=[%noun [%deploy mutable=%.n cont=contract interface=~]]]
:sequencer|batch
```


set allowance for `SQUID`:
```
:uqbar &wallet-poke [%transaction ~ from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x7abb.3cfe.50ef.afec.95b7.aa21.4962.e859.87a0.b22b.ec9b.3812.69d3.296b.24e1.d72a town=0x0 action=[%noun [%set-allowance 0xbd1.f4a1.b3eb.85b4.157f.bff2.3945.3ff8.8104.b8ac.425d.74f5.a799.d159.54a5.dc8b 300.000.000.000.000.000.000 0xe3e.17c6.36d1.f0a7.d037.9553.9d60.f44c.8a8b.d57a.f800.bab2.334e.60a2.3cda.4d17]]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xef51.9805.07e7.f693.e499.f705.777f.2d00 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

set allowance for `ZIG`:
```
:uqbar &wallet-poke [%transaction ~ from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%noun [%set-allowance 0xbd1.f4a1.b3eb.85b4.157f.bff2.3945.3ff8.8104.b8ac.425d.74f5.a799.d159.54a5.dc8b 300.000.000.000.000.000.000 0x7810.2b9f.109c.e44e.7de3.cd7b.ea4f.45dd.aed8.054c.0b52.b2c8.2788.93c6.5bb4.bb85]]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0x7f48.5427.e0d8.60ee.39b2.bbcb.23c5.9973 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

Initialize the AMM gall app with our wallet address:
```
:amm &amm-action [%set-our-address 0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70]
:amm &amm-action [%connect ~]
```

start the pool! (initializing with 100 ZIG and 100 ST):
```
:amm &amm-action [%start-pool token-a=[0x61.7461.6461.7465.6d2d.7367.697a 100.000.000.000.000.000.000] token-b=[0xd19.a57e.01f2.473b.026f.506b.16a5.ce9b.2580.96fd.07a2.7e59.461a.7386.f3d4.2b56 100.000.000.000.000.000.000]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0x33c6.cf5a.7be4.066e.d512.7540.f0bb.4981 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

do a swap! (paying 0.01 ZIG, expecting to receive *at least* 0.009 ST):
```
:amm &amm-action [%swap pool-id=0x3276.ca9b.72b7.f533.c682.6806.6524.83ca.53e8.83d4.5b29.a6d8.c305.9ecd.9125.4a7f payment=[0x61.7461.6461.7465.6d2d.7367.697a 10.000.000.000.000.000] receive=[0xe3e.17c6.36d1.f0a7.d037.9553.9d60.f44c.8a8b.d57a.f800.bab2.334e.60a2.3cda.4d17 9.000.000.000.000.000]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xbede.aca7.cfb6.7392.3e1d.3e76.1bfa.586b gas=[rate=1 bud=1.000.000]]
```
