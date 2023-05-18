/-  *zig-engine
/+  smart=zig-sys-smart, zink=zink-zink, ethereum
|_  [library=vase jets=jetmap:zink sigs-on=?]
::
::  +engine: the execution engine for Uqbar.
::
++  engine
  |_  [sequencer=caller:smart town-id=@ux batch-num=@ud eth-block-height=@ud]
  ::
  ::  +run: produce a state transition for a given town and mempool
  ::
  ++  run
    |=  [=chain pending=memlist deposits=(list deposit)]
    ^-  state-transition
    =|  st=state-transition
    =|  gas-reward=@ud
    =.  chain.st  chain
    |-
    ?~  pending
      ::  finished with execution:
      ::  (1) handle deposits
      =.  st  (process-deposits st chain deposits)
      ::  (2) put processed txns in correct order
      =.  processed.st  (flop processed.st)
      ::  (3) pay accumulated gas to ourself
      ?~  paid=(~(pay tax p.chain.st) address.sequencer gas-reward)
        st
      %=  st
        p.chain   (put:big p.chain.st u.paid)
        modified  (put:big modified.st u.paid)
      ==
    ::  execute a single transaction and integrate the diff
    ::  if we've already optimistically executed, use that diff
    =*  tx  tx.i.pending
    =/  =output
      ?^  output.i.pending
        u.output.i.pending
      =/  op=[output scry-fees]
        ~(intake eng chain.st tx)
      ::  charge cumulative gas fee for entire transaction
      ::  only charge gas fee if errorcode allows for it
      ?:  |(=(%1 errorcode.op) =(%2 errorcode.op) =(%3 errorcode.op))
        -.op
      =/  total-scry-fees=@ud
        (roll ~(val by +.op) add)
      =/  gas-item
        %-  ~(charge tax p.chain.st)
        [modified.op caller.tx gas.op]
      ::  if there were scry payments in the execution, add to the diff
      ::  a payment to the gas token account of each paid contract
      =/  payments=(list [id:smart item:smart])
        %+  murn  ~(tap by +.op)
        |=  [to=id:smart amt=@ud]
        (~(pay tax p.chain.st) to (mul amt rate.gas.tx))
      %=  -.op
        gas  (sub gas.op total-scry-fees)  ::  only pay sequencer for gas
        modified  (gas:big modified.op [gas-item payments])
      ==
    %=  $
      pending     t.pending
      gas-reward  (add gas-reward (mul gas.output rate.gas.tx))
        st
      %=    st
        modified  (uni:big modified.st modified.output)
        burned    (uni:big burned.st burned.output)
      ::
          processed
        :_  processed.st
        :+  hash.i.pending
          tx.i.pending(status errorcode.output)
        output
      ::
          chain
        :-  %+  dif:big
              (uni:big p.chain.st modified.output)
            burned.output
        ?:  ?=(?(%1 %2) errorcode.output)  q.chain.st
        (put:pig q.chain.st [address nonce]:caller.tx)
      ==
    ==
  ::
  ::  +eng: inner handler for processing each transaction
  ::  intake -> combust -> clean -> exhaust
  ::
  ++  eng
    |_  [=chain tx=transaction:smart]
    +$  move  (quip call:smart diff:smart)
    ::
    ++  intake
      ^-  [output scry-fees]
      ?.  ?:(sigs-on (verify-sig tx) %.y)
        ~&  >>>  "engine: signature mismatch"
        (exhaust bud.gas.tx %1 ~ ~)
      ?.  .=  nonce.caller.tx
          +((gut:pig q.chain address.caller.tx 0))
        ~&  >>>  "engine: nonce mismatch"
        (exhaust bud.gas.tx %2 ~ ~)
      ?.  (~(audit tax p.chain) tx)
        ~&  >>>  "engine: tx failed gas audit"
        (exhaust bud.gas.tx %3 ~ ~)
      ::
      =/  gas-payer  address.caller.tx
      |-
      ::  special burn transaction: remove an item from a town and
      ::  reinstantiate it on a different town.
      ::
      ?:  &(=(0x0 contract.tx) =(%burn p.calldata.tx))
        =/  fail  (exhaust bud.gas.tx %9 ~ ~)
        ?.  ?=([id=@ux town=@ux] q.calldata.tx)         fail
        ?~  to-burn=(get:big p.chain id.q.calldata.tx)  fail
        ?.  ?|  =(source.p.u.to-burn address.caller.tx)
                =(holder.p.u.to-burn address.caller.tx)
            ==                                          fail
        ?:  =(id.p.u.to-burn zigs.caller.tx)            fail
        ?:  ?=(%| -.u.to-burn)                          fail
        =-  (exhaust (sub bud.gas.tx 1.000) %0 `[~ - ~] ~)
        (gas:big *state ~[id.p.u.to-burn^u.to-burn])
      ::  special withdraw transaction: burn wrapped ETH on a town
      ::  and send it (by rollup contract) to a specified destination
      ::  address on ethereum.
      ::
      ?:  &(=(0x0 contract.tx) =(%withdraw p.calldata.tx))
        =/  fail  (exhaust bud.gas.tx %9 ~ ~)
        ?.  ?=(withdraw-mold q.calldata.tx)            fail
        ?~  item=(get:big p.chain id.q.calldata.tx)    fail
        ?.  ?=(%& -.u.item)                            fail
        ?~  acc=((soft token-account) noun.p.u.item)   fail
        ?.  =(holder.p.u.item address.caller.tx)       fail
        ?.  =(source.p.u.item ueth-contract-id:smart)  fail
        ?.  (gte balance.u.acc amount.q.calldata.tx)   fail
        ::  create "withdraw item"
        ::  use nonce as salt to assert unique item ids for every withdraw
        =*  withdraw-salt  nonce.caller.tx
        =/  withdraw-item-id=id:smart
          %-  hash-data
          [ueth-contract-id:smart address.caller.tx town-id withdraw-salt]
        =/  withdraw-item=item:smart
          :*  %&  withdraw-item-id
              ueth-contract-id:smart
              address.caller.tx
              town-id  withdraw-salt
              %withdraw  q.calldata.tx
          ==
        =/  event=contract-event
          [ueth-contract-id:smart %withdraw q.calldata.tx]
        =-  (exhaust (sub bud.gas.tx 1.000) %0 `[- ~ event^~] ~)
        =+  u.acc(balance (sub balance.u.acc amount.q.calldata.tx))
        %+  gas:big  *state
        ~[id.p.u.item^u.item(noun.p -) id.p.withdraw-item^withdraw-item]
      ::  normal transaction
      ::
      =?    q.calldata.tx
          ?&  =(contract.tx zigs-contract-id:smart)
              =(p.calldata.tx %give)
          ==
        ::  if transaction is a %give call to zigs contract, inject gas
        ::  budget into the calldata. this is so zigs contract can make sure
        ::  transactions that spend zigs can also afford to pay gas.
        ::  only assert budget check when gas-payer is interacting
        ?.  =(address.caller.tx gas-payer)
          [0 q.calldata.tx]
        [bud.gas.tx q.calldata.tx]
      ?~  pac=(get:big p.chain contract.tx)
        ~&  >>>  "engine: call to missing pact"
        (exhaust bud.gas.tx %4 ~ ~)
      ?.  ?=(%| -.u.pac)
        ~&  >>>  "engine: call to data, not pact"
        (exhaust bud.gas.tx %5 ~ ~)
      ::  build context for call,
      ::  call +combust to get move/hints/gas/error
      ::
      =/  =context:smart
        [contract.tx [- +<]:caller.tx batch-num eth-block-height town-id]
      =/  [mov=(unit move) fees=scry-fees gas-remaining=@ud =errorcode:smart]
        (combust code.p.u.pac context calldata.tx bud.gas.tx)
      ?~  mov  (exhaust gas-remaining errorcode ~ fees)
      =*  calls  -.u.mov
      =*  diff   +.u.mov
      ?.  (clean diff contract.tx zigs.caller.tx)
        (exhaust gas-remaining %7 ~ fees)
      =/  all-diffs   (uni:big changed.diff issued.diff)
      =/  all-burns   burned.diff
      =/  all-events=(list contract-event)
        %+  turn  events.diff
        |=  i=[@tas *]
        [contract.tx i]
      |-  ::  inner loop for handling continuation-calls
      ?~  calls
        ::  diff-only result, finished calling
        (exhaust gas-remaining %0 `[all-diffs all-burns all-events] fees)
      =.  p.chain
        (dif:big (uni:big p.chain all-diffs) burned.diff)
      ::  run continuation calls
      =/  inter=[output =scry-fees]
        %=    ^$
            p.chain
          (dif:big (uni:big p.chain all-diffs) burned.diff)
        ::
            tx
          %=  tx
            bud.gas         gas-remaining
            address.caller  contract.tx
            contract        contract.i.calls
            calldata        calldata.i.calls
          ==
        ==
      ?.  ?=(%0 errorcode.inter)
        ::  if continuation call resulted in an error, fail out immediately
        ::
        (exhaust (sub gas-remaining gas.inter) errorcode.inter ~ fees)
      ::  otherwise, execute next continuation call in the stack
      ::
      %=  $
        calls          t.calls
        gas-remaining  (sub gas-remaining gas.inter)
        all-diffs      (uni:big all-diffs modified.inter)
        all-burns      (uni:big all-burns burned.inter)
        all-events     (weld all-events events.inter)
          fees
        %-  (~(uno by fees) scry-fees.inter)
        |=  [=id:smart f1=@ud f2=@ud]
        (add f1 f2)
      ==
    ::
    ::  +exhaust: prepare final diff for entire call, including all
    ::  subsequent calls created. subtract gas remaining from budget
    ::  to get total spend
    ::
    ++  exhaust
      |=  $:  gas=@ud
              =errorcode:smart
              dif=(unit [mod=state =state e=(list contract-event)])
              =scry-fees
          ==
      :_  scry-fees
      ^-  output
      :+  (sub bud.gas.tx gas)
        errorcode
      ?~  dif  [~ ~ ~]  u.dif
    ::
    ::  +combust: prime contract code for execution, then run using
    ::  ZK-hint-generating virtualized interpreter +zebra. return
    ::  the diff and calls generated, if any, plus gas remaining and error
    ::
    ++  combust
      |=  [code=[bat=* pay=*] =context:smart =calldata:smart bud=@ud]
      ^-  [(unit move) =scry-fees gas=@ud =errorcode:smart]
      |^
      =/  dor=vase  (load code)
      =/  gun  (ajar dor %write !>(context) !>(calldata) %$)
      ::  useful debug prints
      ::  ~&  "context: {<context>}"
      ::  ~&  >  "calldata: {<calldata>}"
      ::  ~&  >>  u.m
      =/  =book:zink
        (zebra:zink bud jets search gun)
      ?:  ?=(%| -.p.book)
        ::  error in contract execution
        [~ pays.q.book gas.q.book %6]
      ?~  p.p.book
        ~&  >>>  "engine: ran out of gas"
        [~ pays.q.book 0 %8]
      ?~  m=((soft (unit move)) p.p.book)
        ::  error in contract execution
        [~ pays.q.book gas.q.book %6]
      [u.m pays.q.book gas.q.book %0]
      ::
      ::  +load: take contract code and combine with smart-lib
      ::
      ++  load
        |=  code=[bat=* pay=*]
        ^-  vase
        :-  -:!>(*contract:smart)
        =/  payload  (mink [q.library pay.code] ,~)
        ?.  ?=(%0 -.payload)  +:!>(*contract:smart)
        =/  cor  (mink [[q.library product.payload] bat.code] ,~)
        ?.  ?=(%0 -.cor)  +:!>(*contract:smart)
        product.cor
      ::
      ::  +search: scry available inside contract runner
      ::  returns an updated gas budget to account for execution
      ::  performed inside the scry, a possible payment to a contract
      ::  with a fee-gated read path, and a noun product.
      ::
      ++  search
        |=  [gas=@ud pit=^]
        ^-  [gas=@ud =scry-fees product=(unit *)]
        =/  rem  (sub gas 100)  ::  FIXED SCRY COST
        ?+    +.pit  rem^~^~
          ::  TODO when typed paths are included in core:
          ::  convert these matching types to good syntax
            [%0 %state [%ux @ux] ~]
          ::  /state/[item-id]
          =/  item-id=id:smart  +.-.+.+.+.pit
          ::  ~&  >>  "looking for item: {<item-id>}"
          ?~  item=(get:big p.chain item-id)
            ::  ~&  >>>  "didn't find it"
            rem^~^~
          rem^~^item
        ::
            [%0 %contract [%ux @ux] ^]
          ::  /contract/[contract-id]/pith/in/contract
          =/  contract-id=id:smart  +.-.+.+.+.pit
          =/  read-pith=pith:smart  ;;(pith:smart +.+.+.+.pit)
          ::  if the first value in the read path is `%fee`, this
          ::  is a *fee-gated* scry path, and the second value will
          ::  be a gas token amount paid to the contract being read from
          =/  fee=(unit [id:smart @ud])
            ?~  read-pith                ~
            ?.  ?=(%fee i.read-pith)     ~
            ?~  t.read-pith              ~
            ?@  i.t.read-pith            ~
            ::  note: value must match fee in contract!
            [~ contract-id `@ud`+.i.t.read-pith]
          ?~  item=(get:big p.chain contract-id)
            ::  ~&  >>>  "didn't find it"
            rem^~^~
          ?.  ?=(%| -.u.item)
            ::  ~&  >>>  "wasn't a pact"
            rem^~^~
          =/  dor=vase  (load code.p.u.item)
          =/  gun
            (ajar dor %read !>(context(this contract-id)) !>(read-pith) %$)
          =/  =book:zink  (zebra:zink rem jets search gun)
          ?:  ?=(%| -.p.book)
            ::  crash inside contract execution
            gas.q.book^~^~
          ?~  p.p.book
            ::  ran out of gas inside execution
            gas.q.book^~^~
          ?~  fee  gas.q.book^pays.q.book^p.p.book
          ?:  (lth gas.q.book +.u.fee)
            ::  cannot afford fee for this scry
            0^pays.q.book^~
          :+  (sub gas.q.book +.u.fee)
            (~(put by pays.q.book) u.fee)
          p.p.book
        ==
      --
    ::
    ::  +clean: validate a diff's changed, issued, and burned items
    ::
    ++  clean
      |=  [=diff:smart source=id:smart caller-zigs=id:smart]
      ^-  ?
      ?&
        %-  ~(all in changed.diff)
        |=  [=id:smart @ =item:smart]
        ::  all changed items must already exist AND
        ::  new item must be same type as old item AND
        ::  id in changed map must be equal to id in item AND
        ::  if data, salt must not change AND
        ::  only items that proclaim us source may be changed
        =/  old  (get:big p.chain id)
        ?&  ?=(^ old)
            ?:  ?=(%& -.u.old)
              &(?=(%& -.item) =(salt.p.u.old salt.p.item))
            =(%| -.item)
            =(id id.p.item)
            =(source.p.item source.p.u.old)
            =(source source.p.u.old)
        ==
      ::
        %-  ~(all in issued.diff)
        |=  [=id:smart @ =item:smart]
        ::  id in issued map must be equal to id in item AND
        ::  source of item must either be contract issuing it or 0x0 AND
        ::  item must not yet exist at that id AND
        ::  item IDs must match defined hashing functions
        ?&  =(id id.p.item)
            |(=(source source.p.item) =(0x0 source.p.item))
            !(has:big p.chain id.p.item)
            ?:  ?=(%| -.item)
              .=  id
              (hash-pact [source holder town code]:p.item)
            .=  id
            (hash-data [source holder town salt]:p.item)
        ==
      ::
        %-  ~(all in burned.diff)
        |=  [=id:smart @ =item:smart]
        ::  all burned items must already exist AND
        ::  id in burned map must be equal to id in item AND
        ::  no burned items may also have been changed at same time AND
        ::  only items that proclaim us source may be burned AND
        ::  burned cannot contain item used to pay for gas
        ::
        ::  NOTE: you *can* modify an item in-contract before burning it.
        ::  the town-id of a burned item marks the town which can REDEEM it.
        ::
        =/  old  (get:big p.chain id)
        ?&  ?=(^ old)
            =(id id.p.item)
            !(has:big changed.diff id)
            =(source.p.item source.p.u.old)
            =(source source.p.u.old)
            !=(caller-zigs id)
        ==
      ==
    --
  ::
  ::  +tax: manage payment for transactions in zigs
  ::
  ++  tax
    |_  =state
    ::  store a copy of the zigs account mold used in zigs.hoon
    +$  token-account
      $:  balance=@ud
          allowances=(pmap:smart sender=address:smart @ud)
          metadata=id:smart
          nonces=(pmap:smart taker=address:smart @ud)
      ==
    ::  +audit: evaluate whether a caller can afford gas
    ::  maximum possible charge is full budget * rate
    ++  audit
      |=  tx=transaction:smart
      ^-  ?
      ?~  zigs=(get:big state zigs.caller.tx)        %.n
      ?.  =(address.caller.tx holder.p.u.zigs)       %.n
      ?.  =(zigs-contract-id:smart source.p.u.zigs)  %.n
      ?.  ?=(%& -.u.zigs)                            %.n
      %+  gte  ;;(@ud -.noun.p.u.zigs)
      (mul bud.gas.tx rate.gas.tx)
    ::  +charge: extract gas fee from caller's zigs balance.
    ::  cannot crash after audit, as long as zigs contract
    ::  adequately validates balance >= budget+amount.
    ++  charge
      |=  [modified=^state payee=caller:smart fee=@ud]
      ^-  [id:smart item:smart]
      ::  if zigs are in modified, use that, otherwise get from state
      =/  zigs=item:smart
        ?^  hav=(get:big modified zigs.payee)  u.hav
        (got:big state zigs.payee)
      ?>  ?=(%& -.zigs)
      =/  balance  ;;(@ud -.noun.p.zigs)
      =-  [zigs.payee zigs(noun.p -)]
      [(sub balance fee) +.noun.p.zigs]
    ::  +pay: give fees from transactions to sequencer and scried contracts
    ++  pay
      |=  [to=id:smart total=@ud]
      ^-  (unit [id.smart item:smart])
      ?:  =(0 total)  ~
      =*  zc  zigs-contract-id:smart
      =/  zigs-account-id
        (hash-data zc to town-id `@`'zigs')
      ::  if receiver doesn't have zigs account, make one for them
      ?~  acc=(get:big state zigs-account-id)
        :-  ~  :-  zigs-account-id
        =+  [total ~ `@ux`'zigs-metadata' ~]
        [%& zigs-account-id zc to town-id `@`'zigs' %account -]
      ?.  ?=(%& -.u.acc)  ~
      =/  account  ;;(token-account noun.p.u.acc)
      ?.  =(`@ux`'zigs-metadata' metadata.account)  ~
      =.  balance.account  (add balance.account total)
      =.  noun.p.u.acc  account
      `[id.p.u.acc u.acc]
    --
  ::
  ::  +process-deposits: take in L1 deposit transactions and
  ::  inject state to produce bridged tokens (TODO support for more)
  ::
  ++  process-deposits
    |=  [st=state-transition =chain deposits=(list deposit)]
    ^-  state-transition
    ?~  deposits  st
    ::  process the deposit bytes
    =*  deposit  i.deposits
    ?>  =(town-id.deposit town-id)
    =/  metadata-id=id:smart
      %:  hash-data:eng
        `@ux`'bridge-pact' :: TODO what is the source of the bridge contract metadata?
        `@ux`'bridge-pact' :: TODO who is holder of the metadata? No one right?
        town-id
        token-contract.deposit
      ==
    =/  acc-id=id:smart
      %:  hash-data:eng
        `@ux`'bridge-pact'  :: TODO what is the source of the bridge contract account?
        destination-address.deposit
        town-id
        token-contract.deposit
      ==
    =;  modified=state
      =.  p.chain.st   (uni:big p.chain modified)
      =.  modified.st  (uni:big p.chain modified)
      $(deposits t.deposits)
    %+  gas:big  *state:eng
    :~  :-  acc-id
        ?^  item=(get:big p.chain acc-id)
          ?>  ?=(%& -.u.item)
          =+  ;;(token-account noun.p.u.item)
          u.item(noun.p -(balance (add balance.- amount.deposit)))
        :*  %&  acc-id
            metadata-id
            destination-address.deposit
            town-id
            token-contract.deposit
            %account
            [amount.deposit ~ metadata-id ~]
        ==
    ::
        :-  metadata-id
        ?^  item=(get:big p.chain metadata-id)
          ?>  ?=(%& -.u.item)
          =+  ;;(token-metadata noun.p.u.item)
          u.item(noun.p -(supply (add supply.- amount.deposit)))
        :*  %&
            metadata-id
            0x0 :: TODO what is source
            0x0
            town-id
            token-contract.deposit
            %token-metadata
            :: TODO make this real
            :*  %name     :: TODO
                %symbol   :: TODO
                %decimals :: TODO
                amount.deposit
                ~
                %.y :: doesn't matter anymore
                ~
                *address:smart
                token-contract.deposit
    ==  ==  ==
  --
::
::  +sort-mempool: order transactions by gas rate, and transactions
::  from same caller by nonce
::
++  sort-mempool
  |=  =mempool
  ^-  memlist
  %+  turn
    %+  sort  ~(tap by mempool)
    |=  [a=[@ux @p tx=transaction:smart] b=[@ux @p tx=transaction:smart]]
    ?:  =(address.caller.tx.a address.caller.tx.b)
      (lth nonce.caller.tx.a nonce.caller.tx.b)
    (gth rate.gas.tx.a rate.gas.tx.b)
  |=  [hash=@ux @p tx=transaction:smart]
  [hash tx ~]
::
::  utilities
::
::
::  reproductions of hashing functions inside smart.hoon for use outside
::  the contract engine.
::
++  hash-pact
  |=  [source=id:smart holder=id:smart town=id:smart code=*]
  ^-  id:smart
  ^-  @ux  %-  shag:merk
  :((cury cat 3) town source holder (sham code))
::
++  hash-data
  |=  [source=id:smart holder=id:smart town=id:smart salt=@]
  ^-  id:smart
  ^-  @ux  %-  shag:merk
  :((cury cat 3) town source holder salt)
::
++  verify-sig
  |=  tx=transaction:smart
  ^-  ?
  =/  hash=@
    ?~  eth-hash.tx
      (sham +.tx)
    u.eth-hash.tx
  =?  v.sig.tx  (gte v.sig.tx 27)  (sub v.sig.tx 27)
  =/  virt=toon
    %+  mong
      :-  ecdsa-raw-recover:secp256k1:secp:crypto
      [hash sig.tx]
    ,~
  ?.  ?=(%0 -.virt)  %.n  ::  invalid sig
  .=  address.caller.tx
  %-  address-from-pub:key:ethereum
  %-  serialize-point:secp256k1:secp:crypto
  ;;([x=@ y=@] p.virt)
::
::  +ajar: partial shut. builds nock to call inner arm of door with sample,
::  without executing the formula. used to feed computation into zebra
::
++  ajar
  |=  [dor=vase arm=@tas dor-sam=vase arm-sam=vase inner-arm=@tas]
  ^-  (pair)
  =/  typ=type
    [%cell p.dor [%cell p.dor-sam p.arm-sam]]
  =/  gen=hoon
    :-  %cnsg
    :^    [inner-arm ~]
        [%cnsg [arm ~] [%$ 2] [%$ 6] ~]
      [%$ 7]
    ~
  =/  gun  (~(mint ut typ) %noun gen)
  [[q.dor [q.dor-sam q.arm-sam]] q.gun]
::
::  +shut: slam arm in door with sample. only shown for reference,
::  not used in engine.
::  TODO: figure out where to move this, still useful elsewhere
::
++  shut
  |=  [dor=vase arm=@tas dor-sam=vase arm-sam=vase inner-arm=@tas]
  ^-  vase
  %+  slap
    (slop dor (slop dor-sam arm-sam))
  ^-  hoon
  :-  %cnsg
  :^    [inner-arm ~]
      [%cnsg [arm ~] [%$ 2] [%$ 6] ~]  ::  replace sample
    [%$ 7]
  ~
--