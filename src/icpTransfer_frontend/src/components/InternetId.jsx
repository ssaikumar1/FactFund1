import { InternetIdentityProvider } from "ic-use-internet-identity";

export  default function Internetid() {
    const { login, loginStatus } = useInternetIdentity();
  
    const disabled = loginStatus === "logging-in" || loginStatus === "success";
    const text = loginStatus === "logging-in" ? "Logging in..." : "Login";
  
    return (
      <button onClick={login} disabled={disabled}>
        {text}
      </button>
    );
  }