import { useEffect, useState } from 'react';
import { canisterId, idlFactory, createActor } from '../../declarations/icpTransfer_backend';
import { ConnectBtn } from './components/ConnectBtn';

function App() {

  const [isPlugAvailable, setIsPlugAvailable] = useState(false)
  const [principal, setPrincipal] = useState(null)
  const [accountId, setAccountId] = useState(null)
  const [isConnected, setIsConnected] = useState(false)
  const [actor, setActor] = useState(null)


  useEffect(() => {
    async function init() {
      if (window.ic.plug) {
        setIsPlugAvailable(true)
        const connected = await window.ic.plug.isConnected();
        setIsConnected(connected)
        if (connected) {
          setPrincipal(window.ic.plug.principalId)
          setAccountId(window.ic.plug.accountId)
          const actor = await window.ic.plug.createActor({ canisterId: canisterId, interfaceFactory: idlFactory });
          setActor(actor)
        }
      }
    }
    init()
  }, [])

  return (
    <>
      <ConnectBtn isConnected={isConnected} principal={principal} setPrincipal={setPrincipal} setAccountId={setAccountId} setIsConnected={setIsConnected} setActor={setActor} />
      <br></br>
      <div>
        
      </div>
    </>
  );
}

export default App;
