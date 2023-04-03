import { useEffect } from 'react';
import { Link } from 'react-router-dom'
import { AccountSelector, useWalletStore } from '@uqbar/wallet-ui';
import './styles/Navbar.scss'
import useAmmStore from '../store/ammStore';
import StatusBlink from './StatusBlink';
const Navbar = () => {
  const { selectedAccount, setSelectedAccount, loadingText } = useWalletStore()
  const { account, checkCurrentAccount, connect, syncing } = useAmmStore()


  //  this useEffect is to keep the amm gall app synced with the wallet-ui selected address
  // %scrying after every account change might be slöw, let's make it better
  useEffect(() => {
    console.log('selection changed, %wallet-selectedAcc and amm-our-account: ', selectedAccount?.rawAddress, account)
    if (!selectedAccount) {
      console.log('no selected account???')
      // only issue I've found here if for some reason useWalletStore() gets stuck on loading
      // also if one nukes the %amm, subs get cleared, but not on %indexer side, so first %connect after nuke will yield duplicate sub
    } else if (selectedAccount?.rawAddress === account) {
      console.log('accounts set correctly.')
    } else {
      checkCurrentAccount(selectedAccount?.rawAddress)
    }
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
      </div>
      <div className="account-selector-container">
        <StatusBlink />
        <AccountSelector
          onSelectAccount={(account) => checkCurrentAccount(account.rawAddress)}
        />
      </div>
    </div>

  )
}

export default Navbar