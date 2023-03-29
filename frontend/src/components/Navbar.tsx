import { useEffect } from 'react';
import { Link } from 'react-router-dom'
import { AccountSelector, useWalletStore } from '@uqbar/wallet-ui';
import './styles/Navbar.scss'
import useAmmStore from '../store/ammStore';

const Navbar = () => {
  const { selectedAccount, setSelectedAccount } = useWalletStore()
  const { account, checkCurrentAccount, connect }  = useAmmStore()


  //  this useEffect is to keep the amm gall app synced with the wallet-ui selected address
  //  using multiple addresses is important, and the txs state should perhaps map by address
  //  another (perhaps better) option would be to pass "our-address" along with every poke to %amm
  //  actually... hmmm. Each sequence, updates the pool to "our-address" specifically. Interesting. 
  //  how often will things batch in reality? 


  useEffect(() => {
    console.log('selection changed, selected and gall-account: ' , selectedAccount?.rawAddress, account)
  }, [selectedAccount, account])


  return (
    <div className="navbar">
      <div className="navbar-links">
        <Link className="nav-link" to="/">
          /swap
        </Link>
        <Link className="nav-link" to="/pools">
          /pools
        </Link>
        <Link className="nav-link" to="/tokens">
          /tokens
        </Link>
        <button onClick={() => connect()}>connect</button>
      </div>
      <div className="account-selector-container">
        <AccountSelector
          onSelectAccount={(account) => checkCurrentAccount(account.rawAddress)}
        />
      </div>
    </div>

  )
}

export default Navbar