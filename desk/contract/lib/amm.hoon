::  /+  *zig-sys-smart
|%
::  values
++  trading-fee   30
++  lp-fee        25
++  protocol-fee  5
++  our-fungible-contract  0x1234
++  dec-18  1.000.000.000.000.000.000
::  data types
+$  pool
  $:  token-a=[meta=id liq=@ud]  ::  id of metadata grain
      token-b=[meta=id liq=@ud]
      liq-shares=@ud
      liq-token-meta=id
  ==
::
+$  token-args
  $:  meta=id
      liq=@ud
      contract=id
      pool-account=(unit id)
      caller-account=id
  ==
::
::  actions
::
+$  action
  $%  $:  %start-pool
          token-a=token-args
          token-b=token-args
      ==
  ::
      $:  %add-liq
          pool-id=id
          token-a=token-args
          token-b=token-args
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
::
::  helpers
::
++  get-pool-salt
  |=  [meta-a=id meta-b=id]
  ^-  @
  ?:  (gth meta-a meta-b)
    (cat 3 meta-a meta-b)
  (cat 3 meta-b meta-a)
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
::
++  get-give-args
  |=  [metadata-id=id me=id them=id town-id=id]
  ^-  [contract=id their-acc=(unit id) our-acc=id]
  =/  metadata=rice
    =-  ?>  ?=(%& -.m)  +.m
    m=(need (scry-granary metadata-id))
  :+  lord.metadata
    =-  ?~(found=(scry-granary -) ~ `id.p.u.found)
    (fry-rice lord.metadata them town-id salt.metadata)
  (fry-rice lord.metadata me town-id salt.metadata)
--