import './styles/Tokens.scss'
import { DeployToken, CreatePool } from '../components'

const Tokens = () => {

  return (
    <div className='wrapper'>
      <div className='left-wrapper'>
        {/* <Allowances /> */}
        <CreatePool />
      </div>
      <DeployToken />
    </div >
  )
}

export default Tokens