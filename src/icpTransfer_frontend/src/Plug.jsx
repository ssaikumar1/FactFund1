import PlugConnect from '@psychedelic/plug-connect';
import { useEffect } from 'react';

export default function Plug() {




    async function ensureConnection(){
        const connected = await window.ic.plug.isConnected();
        console.log(connected)
        if (!connected) window.ic.plug.requestConnect({ whitelist: [process.env.CANISTER_ID_WALL_BACKEND, process.env.CANISTER_ID_WALL_FRONTEND] });
        console.log("jhgv");
        const requestBalanceResponse = await window.ic.plug.requestBalance();
        console.log("requestBalanceResponse", requestBalanceResponse)
        if (connected && !window.ic.plug.agent) {
            window.ic.plug.createAgent({ whitelist: [process.env.CANISTER_ID_WALL_BACKEND, process.env.CANISTER_ID_WALL_FRONTEND] })
        }
    }

    useEffect(() => { conn() }, [])
    async function conn() {
        
    }

    return (
        <>
            <PlugConnect
                whitelist={[process.env.CANISTER_ID_WALL_BACKEND, process.env.CANISTER_ID_WALL_FRONTEND]}
                onConnectCallback={
                    async () => console.log(await window.ic.plug.agent.getPrincipal())
                } />
        </>
    );
}