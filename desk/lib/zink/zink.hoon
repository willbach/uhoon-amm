/-  *zink
/+  *zink-pedersen, *zink-json, merk
=>  |%
    +$  good      (unit *)
    +$  fail      (list [@ta *])
    +$  body      (each good fail)
    +$  cache     (map * phash)
    +$  appendix  [cax=cache hit=hints bud=@]
    +$  book      (pair body appendix)
    --
|%
++  zebra                                                 ::  bounded zk +mule
  |=  [bud=@ud cax=cache scry=granary-scry [s=* f=*] test-mode=?]
  ^-  book
  %.  [s f scry test-mode]
  %*  .  zink
    app  [cax ~ bud]
  ==
::
++  hash
  |=  [n=* cax=(map * phash)]
  ^-  phash
  ?@  n
    ?:  (lte n 12)
      =/  ch  (~(get by cax) n)
      ?^  ch  u.ch
      (hash:pedersen n 0)
    (hash:pedersen n 0)
  ?^  ch=(~(get by cax) n)
    u.ch
  =/  hh  $(n -.n)
  =/  ht  $(n +.n)
  (hash:pedersen hh ht)
::
++  create-hints
  |=  [n=^ h=hints cax=cache]
  ^-  json
  =/  hs  (hash -.n cax)
  =/  hf  (hash +.n cax)
  %-  pairs:enjs:format
  :~  hints+(hints:enjs h)
      subject+s+(num:enjs hs)
      formula+s+(num:enjs hf)
  ==
::
++  zink
  =|  appendix
  =*  app  -
  =|  trace=fail
  |=  [s=* f=* scry=granary-scry test-mode=?]
  ^-  book
  |^
  |-
  ?+    f
    ~&  f
    [%|^trace app]
  ::
      [^ *]
    =^  hed=body  app
      $(f -.f)
    ?:  ?=(%| -.hed)  ~&  61  [%|^trace app]
    ?~  p.hed  [%&^~ app]
    =^  tal=body  app
      $(f +.f)
    ?:  ?=(%| -.tal)  ~&  65  [%|^trace app]
    ?~  p.tal  [%&^~ app]
    =^  hhed=(unit phash)  app  (hash -.f)
    ?~  hhed  [%&^~ app]
    =^  htal=(unit phash)  app  (hash +.f)
    ?~  htal  [%&^~ app]
    :-  [%& ~ u.p.hed^u.p.tal]
    app(hit [%cons u.hhed u.htal]^hit)
  ::
      [%0 axis=@]
    =^  part  bud
      (frag axis.f s bud)
    ?~  part  [%&^~ app]
    ?~  u.part  ~&  78  [%|^trace app]
    =^  hpart=(unit phash)         app  (hash u.u.part)
    ?~  hpart  [%&^~ app]
    =^  hsibs=(unit (list phash))  app  (merk-sibs s axis.f)
    ?~  hsibs  [%&^~ app]
    :-  [%& ~ u.u.part]
    app(hit [%0 axis.f u.hpart u.hsibs]^hit)
  ::
      [%1 const=*]
    =^  hres=(unit phash)  app  (hash const.f)
    ?~  hres  [%&^~ app]
    :-  [%& ~ const.f]
    app(hit [%1 u.hres]^hit)
  ::
      [%2 sub=* for=*]
    =^  hsub=(unit phash)  app  (hash sub.f)
    ?~  hsub  [%&^~ app]
    =^  hfor=(unit phash)  app  (hash for.f)
    ?~  hfor  [%&^~ app]
    =^  subject=body  app
      $(f sub.f)
    ?:  ?=(%| -.subject)  ~&  99  [%|^trace app]
    ?~  p.subject  [%&^~ app]
    =^  formula=body  app
      $(f for.f)
    ?:  ?=(%| -.formula)  ~&  103  [%|^trace app]
    ?~  p.formula  [%&^~ app]
    %_  $
      s    u.p.subject
      f    u.p.formula
      hit  [%2 u.hsub u.hfor]^hit
    ==
  ::
      [%3 arg=*]
    =^  argument=body  app
      $(f arg.f)
    ?:  ?=(%| -.argument)  ~&  114  [%|^trace app]
    ?~  p.argument  [%&^~ app]
    =^  harg=(unit phash)  app  (hash arg.f)
    ?~  harg  [%&^~ app]
    ?@  u.p.argument
      :-  [%& ~ %.n]
      app(hit [%3 u.harg %atom u.p.argument]^hit)
    =^  hhash=(unit phash)  app  (hash -.u.p.argument)
    ?~  hhash  [%&^~ app]
    =^  thash=(unit phash)  app  (hash +.u.p.argument)
    ?~  thash  [%&^~ app]
    :-  [%& ~ %.y]
    app(hit [%3 u.harg %cell u.hhash u.thash]^hit)
  ::
      [%4 arg=*]
    =^  argument=body  app
      $(f arg.f)
    ?:  ?=(%| -.argument)  ~&  131  [%|^trace app]
    =^  harg=(unit phash)  app  (hash arg.f)
    ?~  harg  [%&^~ app]
    ?~  p.argument  [%&^~ app]
    ?^  u.p.argument  ~&  135  [%|^trace app]
    :-  [%& ~ .+(u.p.argument)]
    app(hit [%4 u.harg u.p.argument]^hit)
  ::
      [%5 a=* b=*]
    =^  ha=(unit phash)  app  (hash a.f)
    ?~  ha  [%&^~ app]
    =^  hb=(unit phash)  app  (hash b.f)
    ?~  hb  [%&^~ app]
    =^  a=body  app
      $(f a.f)
    ?:  ?=(%| -.a)  ~&  146  [%|^trace app]
    ?~  p.a  [%&^~ app]
    =^  b=body  app
      $(f b.f)
    ?:  ?=(%| -.b)  ~&  150  [%|^trace app]
    ?~  p.b  [%&^~ app]
    :-  [%& ~ =(u.p.a u.p.b)]
    app(hit [%5 u.ha u.hb]^hit)
  ::
      [%6 test=* yes=* no=*]
    =^  htest=(unit phash)  app  (hash test.f)
    ?~  htest  [%&^~ app]
    =^  hyes=(unit phash)   app  (hash yes.f)
    ?~  hyes  [%&^~ app]
    =^  hno=(unit phash)    app  (hash no.f)
    ?~  hno  [%&^~ app]
    =^  result=body  app
      $(f test.f)
    ?:  ?=(%| -.result)  ~&  164  [%|^trace app]
    ?~  p.result  [%&^~ app]
    =.  hit  [%6 u.htest u.hyes u.hno]^hit
    ?+  u.p.result  ~&  167  [%|^trace app]
      %&  $(f yes.f)
      %|  $(f no.f)
    ==
  ::
      [%7 subj=* next=*]
    =^  hsubj=(unit phash)  app  (hash subj.f)
    ?~  hsubj  [%&^~ app]
    =^  hnext=(unit phash)  app  (hash next.f)
    ?~  hnext  [%&^~ app]
    =^  subject=body  app
      $(f subj.f)
    ?:  ?=(%| -.subject)  ~&  179  [%|^trace app]
    ?~  p.subject  [%&^~ app]
    %_  $
      s    u.p.subject
      f    next.f
      hit  [%7 u.hsubj u.hnext]^hit
    ==
  ::
      [%8 head=* next=*]
    =^  hhead=(unit phash)  app  (hash head.f)
    ?~  hhead  [%&^~ app]
    =^  hnext=(unit phash)  app  (hash next.f)
    ?~  hnext  [%&^~ app]
    =^  head=body  app
      $(f head.f)
    ?:  ?=(%| -.head)  ~&  198  [%|^trace app]
    ?~  p.head  [%&^~ app]
    %_  $
      s    [u.p.head s]
      f    next.f
      hit  [%8 u.hhead u.hnext]^hit
    ==
  ::
      [%9 axis=@ core=*]
    =^  hcore=(unit phash)  app  (hash core.f)
    ?~  hcore  [%&^~ app]
    =^  core=body  app
      $(f core.f)
    ?:  ?=(%| -.core)  ~&  211  [%|^trace app]
    ?~  p.core  [%&^~ app]
    =^  arm  bud
      (frag axis.f u.p.core bud)
    ?~  arm  [%&^~ app]
    ?~  u.arm  ~&  216  [%|^trace app]
    =^  harm=(unit phash)  app  (hash u.u.arm)
    ?~  harm  [%&^~ app]
    =^  hsibs=(unit (list phash))  app  (merk-sibs u.p.core axis.f)
    ?~  hsibs  [%&^~ app]
    %_  $
      s    u.p.core
      f    u.u.arm
      hit  [%9 axis.f u.hcore u.harm u.hsibs]^hit
    ==
  ::
      [%10 [axis=@ value=*] target=*]
    =^  hval=(unit phash)  app  (hash value.f)
    ?~  hval  [%&^~ app]
    =^  htar=(unit phash)  app  (hash target.f)
    ?~  htar  [%&^~ app]
    ?:  =(0 axis.f)  ~&  232  [%|^trace app]
    =^  target=body  app
      $(f target.f)
    ?:  ?=(%| -.target)  ~&  235  [%|^trace app]
    ?~  p.target  [%&^~ app]
    =^  value=body  app
      $(f value.f)
    ?:  ?=(%| -.value)  ~&  239  [%|^trace app]
    ?~  p.value  [%&^~ app]
    =^  mutant=(unit (unit *))  bud
      (edit axis.f u.p.target u.p.value bud)
    ?~  mutant  [%&^~ app]
    ?~  u.mutant  ~&  244  [%|^trace app]
    =^  oldleaf  bud
      (frag axis.f u.p.target bud)
    ?~  oldleaf  [%&^~ app]
    ?~  u.oldleaf  ~&  248  [%|^trace app]
    =^  holdleaf=(unit phash)  app  (hash u.u.oldleaf)
    ?~  holdleaf  [%&^~ app]
    =^  hsibs=(unit (list phash))  app  (merk-sibs u.p.target axis.f)
    ?~  hsibs  [%&^~ app]
    :-  [%& ~ u.u.mutant]
    app(hit [%10 axis.f u.hval u.htar u.holdleaf u.hsibs]^hit)
  ::
       [%11 tag=@ next=*]
    ~&  >  `@tas`tag.f
    =^  next=body  app
      $(f next.f)
    :_  app
    ?:  ?=(%| -.next)  ~&  260  %|^trace
    ?~  p.next  %&^~
    :+  %&  ~
    .*  s
    [11 tag.f 1 u.p.next]
  ::
      [%11 [tag=@ clue=*] next=*]
    ::  look for jet with this tag and compute sample
    ::  ~&  >  "hint: {<`@tas`tag.f>}"
    ::  ~?  ?=(%fast tag.f)
    ::    ?>  ?=([@ @ [@ @] @] clue.f)
    ::    "jet: {<`@tas`-.+.clue.f>}"
    =^  sam=body  app
      $(f clue.f)
    ?:  ?=(%| -.sam)  ~&  269  [%|^trace app]
    ?~  p.sam  [%&^~ app]
    ::  if jet exists for this tag, and sample is good,
    ::  replace execution with jet
    =^  jax=body  app
      (jet tag.f u.p.sam)
    ?:  ?=(%| -.jax)  ~&  190  [%|^trace app]
    ?^  p.jax  [%& p.jax]^app
    ::  jet not found, proceed with normal computation
    =^  clue=body  app
      $(f clue.f)
    ?:  ?=(%| -.clue)  ~&  269  [%|^trace app]
    ?~  p.clue  [%&^~ app]
    =^  next=body  app
      =?    trace
          ?=(?(%hunk %hand %lose %mean %spot) tag.f)
        [[tag.f u.p.clue] trace]
      $(f next.f)
    :_  app
    ?:  ?=(%| -.next)  ~&  286  %|^trace
    ?~  p.next  %&^~
    :+  %&  ~
    .*  s
    [11 [tag.f 1 u.p.clue] 1 u.p.next]
  ::
      [%12 ref=* path=*]
    ::  TODO hash ref, path and grain id parsed as last item in path
    ::       hash product and path through granary merkle tree
    ::       (similar process in nock 0)
    =^  ref=body  app
      $(f ref.f)
    ?:  ?=(%| -.ref)     ~&  289  [%|^trace app]
    ?~  p.ref            [%&^~ app]
    =^  path=body  app
      $(f path.f)
    ?:  ?=(%| -.path)    ~&  293  [%|^trace app]
    ?~  p.path           [%&^~ app]
    =/  result  (scry bud p.ref p.path)
    ?~  product.result
      [%&^~^~ app(bud bud.result)]
    [%&^[~ product.result] app(bud bud.result)]
  ==
  ::
  ++  jet
    |=  [tag=@ sam=*]
    ^-  book
    ?:  ?=(%slog tag)
      ::  print trace printfs?
      [%&^~ app]
    ?:  ?=(%mean tag)
      ::  this is a crash..
      ~&  317  [%|^trace app]
    ?~  cost=(~(get by jets) tag)
      ~&  >>  "no jet found"  [%&^~ app]
    ?:  (lth bud u.cost)  [%&^~ app]
    :-  (run-jet tag sam u.cost)
    app(bud (sub bud u.cost))
  ::
  ++  run-jet
    |=  [tag=@ sam=* cost=@ud]
    ^-  body
    ::  TODO: probably unsustainable to need to include assertions to
    ::  make all jets crash safe.
    ?+    tag  %|^trace
    ::                                                                       ::
    ::  math                                                                 ::
    ::                                                                       ::
        %add
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (add sam))
    ::
        %dec
      ?.  ?=(@ sam)  %|^trace
      %&^(some (dec sam))
    ::
        %div
      ?.  ?=([@ @] sam)  %|^trace
      ?.  (gth +.sam 0)  %|^trace
      %&^(some (div sam))
    ::
        %dvr
      ?.  ?=([@ @] sam)  %|^trace
      ?.  (gth +.sam 0)  %|^trace
      %&^(some (dvr sam))
    ::
        %gte
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (gte sam))
    ::
        %gth
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (gth sam))
    ::
        %lte
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (lte sam))
    ::
        %lth
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (lth sam))
    ::
        %max
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (max sam))
    ::
        %min
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (min sam))
    ::
        %mod
      ?.  ?=([@ @] sam)  %|^trace
      ?.  (gth +.sam 0)  %|^trace
      %&^(some (mod sam))
    ::
        %mul
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (mul sam))
    ::
        %sub
      ?.  ?=([@ @] sam)      %|^trace
      ?.  (gte -.sam +.sam)  %|^trace
      %&^(some (sub sam))
    ::                                                                       ::
    ::  bits                                                                 ::
    ::                                                                       ::
        %bex
      ?.  ?=(bloq sam)  %|^trace
      %&^(some (bex sam))
    ::
        %can
      ::  TODO validate
      %&^(some (slum can sam))
    ::
        %cat
      ?.  ?=([bloq @ @] sam)  %|^trace
      %&^(some (cat sam))
    ::
        %cut
      ?.  ?=([bloq [step step] @] sam)  %|^trace
      %&^(some (cut sam))
    ::
        %end
      ?.  ?=([bite @] sam)  %|^trace
      %&^(some (end sam))
    ::
        %fil
      ?.  ?=([bloq step @] sam)  %|^trace
      %&^(some (fil sam))
    ::
        %lsh
      ?.  ?=([bloq @] sam)  %|^trace
      %&^(some (lsh sam))
    ::
        %met
      ?.  ?=([bloq @] sam)  %|^trace
      %&^(some (met sam))
    ::
        %rap
      ::  TODO validate
      %&^(some (slum rap sam))
    ::
        %rep
      ::  TODO validate
      %&^(some (slum rep sam))
    ::
        %rev
      ?.  ?=([bloq @ud @] sam)  %|^trace
      %&^(some (rev sam))
    ::
        %rip
      ?.  ?=([bite @] sam)  %|^trace
      %&^(some (rip sam))
    ::
        %rsh
      ?.  ?=([bite @] sam)  %|^trace
      %&^(some (rsh sam))
    ::
        %run
      ::  TODO validate
      %&^(some (slum run sam))
    ::
        %rut
      ::  TODO validate
      %&^(some (slum rut sam))
    ::
        %sew
      ?.  ?=([bloq [step step @] @] sam)  %|^trace
      %&^(some (sew sam))
    ::
        %swp
      ?.  ?=([bloq @] sam)  %|^trace
      %&^(some (swp sam))
    ::
        %xeb
      ?.  ?=(@ sam)  %|^trace
      %&^(some (xeb sam))
    ::
    ::                                                                       ::
    ::  list                                                                 ::
    ::                                                                       ::
      ::  this one actually fails, so really need to find a better way.
      ::    %turn
      ::  ::  TODO: determine how best to validate complex jet inputs
      ::  ::  this will crash if the input is bad.
      ::  %&^(some (slum turn sam))
    ::                                                                       ::
    ::  sha                                                                  ::
    ::                                                                       ::
        %sham
      %&^(some (sham sam))
    ::
        %shax
      ?.  ?=(@ sam)  %|^trace
      %&^(some (shax sam))
    ::
        %shay
      ?.  ?=([@u @] sam)  %|^trace
      %&^(some (shay sam))
    ::                                                                       ::
    ::  etc                                                                  ::
    ::                                                                       ::
        %need
      ?.  ?=((unit) sam)  %|^trace
      ?:  ?=(~ sam)       %|^trace
      %&^(some (need sam))
    ::
        %scot
      ?.  ?=([@ta @] sam)  %|^trace
      %&^(some (scot sam))
    ::
        %pedersen-hash
      ?.  ?=([@ @] sam)  %|^trace
      %&^(some (hash:pedersen sam))
    ::
        %shag
      %&^(some (shag:merk sam))
    ==
  ::
  ++  frag
    |=  [axis=@ noun=* bud=@ud]
    ^-  [(unit (unit)) @ud]
    ?:  =(0 axis)  [`~ bud]
    |-  ^-  [(unit (unit)) @ud]
    ?:  =(0 bud)  [~ bud]
    ?:  =(1 axis)  [``noun (dec bud)]
    ?@  noun  [`~ (dec bud)]
    =/  pick  (cap axis)
    %=  $
      axis  (mas axis)
      noun  ?-(pick %2 -.noun, %3 +.noun)
      bud   (dec bud)
    ==
  ::
  ++  edit
    |=  [axis=@ target=* value=* bud=@ud]
    ^-  [(unit (unit)) @ud]
    ?:  =(1 axis)  [``value bud]
    ?@  target  [`~ bud]
    ?:  =(0 bud)  [~ bud]
    =/  pick  (cap axis)
    =^  mutant  bud
      %=  $
        axis    (mas axis)
        target  ?-(pick %2 -.target, %3 +.target)
        bud     (dec bud)
      ==
    ?~  mutant  [~ bud]
    ?~  u.mutant  [`~ bud]
    ?-  pick
      %2  [``[u.u.mutant +.target] bud]
      %3  [``[-.target u.u.mutant] bud]
    ==
  ::
  ++  hash
    |=  n=*
    ^-  [(unit phash) appendix]
    ::  test mode disables hashing, so it won't generate valid hints.
    ::  however, computation is *much* faster since hashing is the
    ::  most expensive aspect of the process.
    ?:  test-mode  [`0x1 app]
    =/  mh  (~(get by cax) n)
    ?^  mh
      ?:  =(bud 0)  [~ app]
      [mh app(bud (dec bud))]
    ?@  n
      ?:  =(bud 0)  [~ app]
      =/  h  (hash:pedersen n 0)
      :-  `h
      app(cax (~(put by cax) n h), bud (dec bud))
    =^  hh=(unit phash)  app  $(n -.n)
    ?~  hh  [~ app]
    =^  ht=(unit phash)  app  $(n +.n)
    ?~  ht  [~ app]
    =/  h  (hash:pedersen u.hh u.ht)
    ?:  =(bud 0)  [~ app]
    :-  `h
    app(cax (~(put by cax) n h), bud (dec bud))
  ::
  ++  merk-sibs
    |=  [s=* axis=@]
    =|  path=(list phash)
    |-  ^-  [(unit (list phash)) appendix]
    ?:  =(1 axis)
      [`path app]
    ?~  axis  !!
    ?@  s  !!
    =/  pick  (cap axis)
    =^  sibling=(unit phash)  app
      %-  hash
      ?-(pick %2 +.s, %3 -.s)
    ?~  sibling  [~ app]
    =/  child  ?-(pick %2 -.s, %3 +.s)
    %=  $
      s     child
      axis  (mas axis)
      path  [u.sibling path]
    ==
  --
--
