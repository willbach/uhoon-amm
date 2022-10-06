/+  *zig-sys-smart
|%
::  values
++  our-fungible-contract
  0x1234.5678.1234.5678
::  data types
+$  pool
  $:  token-a=[meta=id liq=@ud]  ::  id of metadata grain
      token-b=[meta=id liq=@ud]
      liq-shares=@ud
  ==
::
::  actions
::
+$  action
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
          token-account-a=(unit id)
          token-account-b=(unit id)
      ==
  ::
      $:  %swap
          pool-id=id
          payment=[meta=id amount=@ud]
      ==
  ==
--