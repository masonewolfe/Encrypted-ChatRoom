import React, { useContext, useState } from "react";
import { useUser } from "./UserContext";

const XmppContext = React.createContext();
const simpleXmpp = require("simple-xmpp");

export function useXmpp() {
  return useContext(XmppContext);
}

export function XmppProvider({ children }) {
  // const { user } = useUser();
  const [status, setStatus] = useState("test-offline");

  simpleXmpp.connect({
    jid: "joey@cipher.com",
    password: "password",
    host: "3.91.204.251",
    port: 5222,
  });
  simpleXmpp.on("online", (data) => {
    console.log("Welcome " + data.jid.user);
    setStatus("online");
  });

  const value = {
    status,
  };

  return (
    <XmppContext.Provider value={value}>
      {children}
    </XmppContext.Provider>
  );
}
