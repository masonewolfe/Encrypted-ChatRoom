import React, { createContext, useDebugValue, useEffect, useState } from "react";

export default function Testground() {
  const [count, setCount] = useState(0);
  const moods = {
    happy: "yes",
    sad: "no",
  };
  const MoodContext = createContext(moods);

  function useDisplayName() {
    const [displayName, setDisplayName] = useState();

    useEffect(() => {
      const data = "joey";
      setDisplayName(data);
    }, []);

    useDebugValue(displayName ?? 'loading...');

    return displayName;
  }

  return (
    <MoodContext.Provider value={moods.happy}>
      <div>Testground</div>
      <button onClick={() => setCount(count + 1)}>{count}</button>
      <h2>name = {useDisplayName()}</h2>
    </MoodContext.Provider>
  );
}
