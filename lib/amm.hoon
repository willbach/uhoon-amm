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
::
::  helpers
::
++  get-take-args
  |=  [metadata-id=id me=id them=id town-id=id]
  ^-  [contract=id their-acc=id our-acc=(unit id)]
  =/  metadata=rice
    =-  ?>  ?=(%& -.m)  +.m
    m=(need (scry-granary metadata-id))
  :+  lord.metadata
    (fry-rice lord.metadata them town-id salt.metadata)
  =-  ?~(found=(scry-granary -) ~ `id.p.u.found)
  (fry-rice lord.metadata me town-id salt.metadata)
--