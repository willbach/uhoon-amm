/-  *amm, indexer
|%
++  get-from-chain
  |=  [contract=id:smart our=ship now=@da]
  ^-  (map id:smart pool-data)
  ::  scry the indexer
  =/  =update:indexer
    .^  update:indexer  %gx
        (scot %p our)  %uqbar  (scot %da now)
        %indexer  %newest  %lord
        0x0  (scot %ux contract)
        noun
    ==
  ~&  >>  update
  ~
--