import { useEffect } from 'react';
import useAmmStore from '../store/ammStore'
import './styles/StatusBlink.scss'

const StatusBlink = () => {
  const { syncing, setSyncing } = useAmmStore();

  return (
    <div className={syncing ? "syncing-indicator" : "greendot"}></div>
  );
};



  export default StatusBlink