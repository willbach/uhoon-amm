# uhoon-amm
AMM contract for Uqbar in the style of Uniswap V2

These commands assume:

- fungible contract ID `0x3819.6d95.acd2.68bd.2b04.7641.e7ff.94d2.ac69.33db.3109.d80f.b9ab.6a47.237d.cd3f`

- AMM contract ID `0xbf0d.33d2.9bb8.182a.2ee7.385e.2be2.307e.d124.ed7f.e9c7.5bfd.cbba.179e.ac61.6fb2`

- You're running the `custom-init` generator here.

We'll first use the wallet dojo CLI to deploy a new token and set some allowances such that the AMM contract can pull from our accounts:

Deploy a token, `ST`:
```
:uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x3819.6d95.acd2.68bd.2b04.7641.e7ff.94d2.ac69.33db.3109.d80f.b9ab.6a47.237d.cd3f town=0x0 action=[%noun [%deploy 'squid token' 'ST' 999 ~ [0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 0 0] ~[[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 300.000.000.000.000.000.000]]]]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0x5c6f.32b8.c4d1.447e.0d30.5ce2.f46c.1625 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

set allowance for `ST`:
```
:uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x3819.6d95.acd2.68bd.2b04.7641.e7ff.94d2.ac69.33db.3109.d80f.b9ab.6a47.237d.cd3f town=0x0 action=[%noun [%set-allowance 0xbf0d.33d2.9bb8.182a.2ee7.385e.2be2.307e.d124.ed7f.e9c7.5bfd.cbba.179e.ac61.6fb2 300.000.000.000.000.000.000 0x1a37.ed03.1b12.8d6a.3c40.cc4f.758f.6219.44ee.bca1.e6fc.25c0.ef52.d757.7742.b9dc]]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xef51.9805.07e7.f693.e499.f705.777f.2d00 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

set allowance for `ZIG`:
```
:uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%noun [%set-allowance 0xbf0d.33d2.9bb8.182a.2ee7.385e.2be2.307e.d124.ed7f.e9c7.5bfd.cbba.179e.ac61.6fb2 300.000.000.000.000.000.000 0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]]
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
:amm &amm-action [%start-pool token-a=[0x61.7461.6461.7465.6d2d.7367.697a 100.000.000.000.000.000.000] token-b=[0xee48.d8de.129a.2d3b.e87b.6570.2621.35b3.dfac.da2f.0ee6.72ff.bbcc.7dc3.cafc.f92b 100.000.000.000.000.000.000]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0x33c6.cf5a.7be4.066e.d512.7540.f0bb.4981 gas=[rate=1 bud=1.000.000]]
:sequencer|batch
```

do a swap! (paying 0.01 ZIG, expecting to receive *at least* 0.009 ST):
```
:amm &amm-action [%swap pool-id=0x9dbb.4d86.ddf4.caaa.f3c3.4856.213d.98f4.46d6.5d2e.5d68.86cd.ba52.29df.7598.3dfb payment=[0x61.7461.6461.7465.6d2d.7367.697a 10.000.000.000.000.000] receive=[0xee48.d8de.129a.2d3b.e87b.6570.2621.35b3.dfac.da2f.0ee6.72ff.bbcc.7dc3.cafc.f92b 9.000.000.000.000.000]]
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xbede.aca7.cfb6.7392.3e1d.3e76.1bfa.586b gas=[rate=1 bud=1.000.000]]
```
