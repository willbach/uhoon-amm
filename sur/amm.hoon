|%
::
::  App to interact with Uqbar AMM contract.
::
::  On init, the app subscribes to all grains controlled by the AMM contract,
::  the address of which is hardcoded below:
::
++  amm-contract-id  0xcafe
::
::  The app then tracks pools and their prices, providing to the user an
::  interface for building transactions for swaps and liquidity management.
::
::  Types from contract:
::
+$  pool
  $:  token-a=[meta=id liq=@ud]  ::  id of metadata grain
      token-b=[meta=id liq=@ud]
      liq-shares=@ud
      liq-token-meta=id
  ==
::
+$  contract-action
  $%  $:  %start-pool
          token-a=[meta=id liq=@ud]
          token-b=[meta=id liq=@ud]
      ==
  ::
      $:  %add-liq
          pool-id=id
          token-a=[meta=id liq=@ud]
          token-b=[meta=id liq=@ud]
      ==
  ::
      $:  %remove-liq
          pool-id=id
          liq-shares-account=id
          amount=@ud
      ==
  ::
      $:  %swap
          pool-id=id
          payment=[meta=id amount=@ud]
          min-output=@ud
      ==
  ==
--