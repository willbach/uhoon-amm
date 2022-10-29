# uhoon-amm
AMM contract for Uqbar in the style of Uniswap V2

These commands assume:

fungible contract ID `0x3d34.bea2.8fab.dfdb.9591.bafd.4960.33aa.8418.2440.29c0.37d1.30c9.75ae.0f5b.c0b8`

AMM contract ID `0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8`

fungible deploy txn:
```[%deploy 'squid token' 'ST' 999 ~ (make-pset ~[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70]) ~[[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 300.000.000.000.000.000.000]]]```

set allowance ST:
```[%set-allowance 0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8 300.000.000.000.000.000.000 0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7]```

set allowance ZIG:
```[%set-allowance 0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8 300.000.000.000.000.000.000 0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]```

start the pool: (initializing with 100 ZIG and 100 ST)
```[%start-pool token-a=[0x61.7461.6461.7465.6d2d.7367.697a 100.000.000.000.000.000.000 ~ `0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6] token-b=[0x5140.1f3d.7237.a7b4.c6b3.8f73.d6e7.5366.4cea.4904.4d47.c43b.6d5e.e017.b1af.2652 100.000.000.000.000.000.000 ~ `0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7]]```

The pool ID from the above initialization *should* be `0xb7cd.ef98.7693.5569.4bc6.f939.b225.17e8.d180.a37e.6dbc.d25f.ac13.aeba.9402.420b`. If so, the below transaction should execute a swap, with an input of 1 ZIG to get a little less than one ST.

do a swap:
```[%swap pool-id=0xb7cd.ef98.7693.5569.4bc6.f939.b225.17e8.d180.a37e.6dbc.d25f.ac13.aeba.9402.420b payment=[0x61.7461.6461.7465.6d2d.7367.697a 1.000.000.000.000.000.000 `0x623b.cd07.a921.08f6.7421.a086.f3c5.0d82.a697.89c0.2c90.fc9a.1a36.b18f.4b73.790b `0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6] receive=[0x5140.1f3d.7237.a7b4.c6b3.8f73.d6e7.5366.4cea.4904.4d47.c43b.6d5e.e017.b1af.2652 100.000.000.000.000.000 `0x50c7.73c0.2356.9fe6.95b9.0fa0.a960.609c.c5d3.8321.bc93.eb2d.0a94.808b.83f8.2f25 `0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7]]```

-----

Deploy another fungible token and make another pool between it and ZIG:

```[%deploy 'loach token' 'LOCH' 123 ~ (make-pset ~[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70]) ~[[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 300.000.000.000.000.000.000]]]```

set allowance LOCH:
```[%set-allowance 0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8 300.000.000.000.000.000.000 0xf198.5f90.0def.03f7.5e19.6ded.6d87.cc6f.dad1.05a8.31c0.5ca9.42ba.defc.ee98.2f04]```

start the pool: (initializing with 1 ZIG and 50 LOCH this time)
```[%start-pool token-a=[0x61.7461.6461.7465.6d2d.7367.697a 1.000.000.000.000.000.000 `0x623b.cd07.a921.08f6.7421.a086.f3c5.0d82.a697.89c0.2c90.fc9a.1a36.b18f.4b73.790b `0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6] token-b=[0x5472.4216.b1b2.20c2.63c3.5294.4e44.98cd.fa1c.30d0.6fb9.f40b.3acc.ccd5.513c.1773 50.000.000.000.000.000.000 ~ `0xf198.5f90.0def.03f7.5e19.6ded.6d87.cc6f.dad1.05a8.31c0.5ca9.42ba.defc.ee98.2f04]]```

-----

Now make a 3rd pool between ST and LOCH: (initializing with 50 LOCH and 2 ST) (arb available!)

```[%start-pool token-a=[0x5140.1f3d.7237.a7b4.c6b3.8f73.d6e7.5366.4cea.4904.4d47.c43b.6d5e.e017.b1af.2652 2.000.000.000.000.000.000 `0x50c7.73c0.2356.9fe6.95b9.0fa0.a960.609c.c5d3.8321.bc93.eb2d.0a94.808b.83f8.2f25 `0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7] token-b=[0x5472.4216.b1b2.20c2.63c3.5294.4e44.98cd.fa1c.30d0.6fb9.f40b.3acc.ccd5.513c.1773 50.000.000.000.000.000.000 `0xb38.cad7.d681.b149.8286.ecdc.8da6.b6ea.4f3f.ec87.9c76.76cf.399d.755c.b829.5d9f `0xf198.5f90.0def.03f7.5e19.6ded.6d87.cc6f.dad1.05a8.31c0.5ca9.42ba.defc.ee98.2f04]]```
