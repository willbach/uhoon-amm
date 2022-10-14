/-  *amm
=,  format
|_  upd=update
++  grab
  |%
  ++  noun  update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ?-  -.upd
      %test
      %-  pairs:enjs
      :~
        ['from-backend' (numb:enjs rnum.upd)]
      ==
      %confirmation
      %-  pairs:enjs
      :~
        ['confirmation' (tape:enjs "Order Received: {<amount.upd token.upd>}")]
      ==
    ==
  --
++  grad  %noun
--