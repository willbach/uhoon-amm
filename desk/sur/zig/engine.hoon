/+  smart=zig-sys-smart, merk
|%
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for state
++  pig  (bi:merk id:smart @ud)         ::                for nonces
::
+$  state   (merk:merk id:smart item:smart)
+$  nonces  (merk:merk address:smart @ud)
+$  chain   $+(chain (pair state nonces))
::
+$  mempool  (map hash=@ux [from=@p tx=transaction:smart])
::  sorted mempool with optional pre-computed output
+$  memlist  (list [hash=@ux tx=transaction:smart output=(unit output)])
+$  processed-txs  (list [tx-hash=@ux tx=transaction:smart =output])
::  map of payments made to other contracts for scries
+$  scry-fees  (map id:smart @ud)
::
+$  state-diff  state  ::  state transitions for one batch
::
::  The engine, at the top level, takes in a chain-state and mempool
::  and produces the resulting state-transition, shown below
::
+$  state-transition
  $:  =chain
      modified=state
      burned=state
      processed=processed-txs
  ==
::
+$  output
  $+  output
  $:  gas=@ud
      =errorcode:smart
      modified=state
      burned=state
      events=(list contract-event)
  ==
::
::  contract events are converted to this
::
+$  contract-event  [contract=id:smart label=@tas noun=*]
::
+$  deposit  ::  matches type generated by rollup contract
  $:  town-id=@ux
      token-contract=@ux
      token-id=@ud :: only for NFTs
      destination-address=address:smart
      amount=@ud
      block-number=@ud
      previous-deposit-root=@ux
      kind=deposit-metadata
  ==
::
::  mold for token metadata associated with deposits
::
+$  deposit-metadata
  $%  [%eth decimals=_18]
      [%erc20 name=@t symbol=@t decimals=@ud]
      [%erc721 name=@t symbol=@t token-uri=@t]
  ==
::
::  the mold for %withdraw transaction calldata
::  only handling uETH currently.
::
+$  withdraw-mold
  $%  $:  %token
          id=id:smart
          eth-token-id=@ud
          destination-address=address:smart
          amount=@ud
      ==
      ::  [%nft id=id:smart]
  ==
::
::  hardcoded molds comporting to account-token standard
::
+$  token-metadata
  $:  name=@t
      symbol=@t
      decimals=@ud
      supply=@ud
      cap=(unit @ud)
      mintable=?
      minters=(pset:smart address:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  token-account
  $:  balance=@ud
      allowances=(pmap:smart sender=address:smart @ud)
      metadata=id:smart
      nonces=(pmap:smart taker=address:smart @ud)
  ==
::
::  hardcoded molds comporting to account-NFT standard
::
+$  nft-metadata
  $:  name=@t
      symbol=@t
      properties=(pset:smart @tas)
      supply=@ud
      cap=(unit @ud)
      mintable=?
      minters=(pset:smart address:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  nft  ::  a non-fungible token
  $:  id=@ud
      uri=@t
      metadata=id:smart
      allowances=(pset:smart address:smart)
      properties=(pmap:smart @tas @t)
      transferrable=?
  ==
--
