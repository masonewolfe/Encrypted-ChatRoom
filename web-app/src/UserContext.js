import React, { useContext, useState, useEffect } from "react";

const UserContext = React.createContext();

export function useUser() {
  return useContext(UserContext);
}

export function UserProvider({ children }) {
  const [currentUser, setCurrentUser] = useState();
  const [loading, setLoading] = useState(true);

  function signup(email, password) {
    return 0;
  }

  function login(email, password) {
    return 0;
  }

  useEffect(() => {
    const unsubscribe = (user) => {
      setCurrentUser(user);
      setLoading(false);
    };

    return unsubscribe;
  }, []);

  const value = {
    currentUser,
    signup,
    login,
  };

  return (
    <UserContext.Provider value={value}>
      {!loading && children}
    </UserContext.Provider>
  );
}
