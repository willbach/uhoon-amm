import './styles/Tokens.scss'
import { DeployToken, CreatePool, Allowances } from '../components'

const Tokens = () => {
  // (deploy tokens) and set their allowance for test

  return (
    <div className='wrapper'>
      <div className='left-wrapper'>
        <Allowances />
        <CreatePool />
      </div>
      <DeployToken />
    </div >
  )
}

export default Tokens