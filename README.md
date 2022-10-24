# uhoon-amm
AMM contract for Uqbar in the style of Uniswap V2

These commands assume:

fungible contract ID `0x5856.b89a.1915.b17a.7bab.9be2.5bc7.7c47.1c9b.ffdf.79f6.5d13.8893.7ca3.137a.7d3e`

AMM contract ID `0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8`

fungible deploy txn:
```[%deploy 'squid token' 'ST' 999 ~ (make-pset ~[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70]) ~[[0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 300.000.000.000.000.000.000]]]```

set allowance fungible:
```[%set-allowance 0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8 300.000.000.000.000.000.000 0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7]```

set allowance zigs:
```[%set-allowance 0xa774.098d.e071.3637.4a04.6d2b.e7e1.e7c6.9de3.2837.7dc6.2516.f7a7.2100.6249.23f8 300.000.000.000.000.000.000 0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]```

start the pool:
```[%start-pool token-a=[0x61.7461.6461.7465.6d2d.7367.697a 100.000.000.000.000.000.000 ~ `0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6] token-b=[0x5140.1f3d.7237.a7b4.c6b3.8f73.d6e7.5366.4cea.4904.4d47.c43b.6d5e.e017.b1af.2652 100.000.000.000.000.000.000 ~ `0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7]]```

The pool ID from the above initialization *should* be `0xb7cd.ef98.7693.5569.4bc6.f939.b225.17e8.d180.a37e.6dbc.d25f.ac13.aeba.9402.420b`. If so, the below transaction should execute a swap, with an input of 1 ZIG to get a little less than one ST.

do a swap:
```[%swap pool-id=0xb7cd.ef98.7693.5569.4bc6.f939.b225.17e8.d180.a37e.6dbc.d25f.ac13.aeba.9402.420b payment=[0x61.7461.6461.7465.6d2d.7367.697a 1.000.000.000.000.000.000 `0x623b.cd07.a921.08f6.7421.a086.f3c5.0d82.a697.89c0.2c90.fc9a.1a36.b18f.4b73.790b `0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6] receive=[0x5140.1f3d.7237.a7b4.c6b3.8f73.d6e7.5366.4cea.4904.4d47.c43b.6d5e.e017.b1af.2652 100.000.000.000.000.000 `0x50c7.73c0.2356.9fe6.95b9.0fa0.a960.609c.c5d3.8321.bc93.eb2d.0a94.808b.83f8.2f25 `0x2a8d.36f4.63b1.1e0b.c6c9.c2e5.30cb.76e6.a8d8.ff52.5a73.a13d.ba83.c28d.78d1.5be7]]```