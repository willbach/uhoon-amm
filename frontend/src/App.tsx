import React, { useEffect } from 'react';
import logo from './logo.svg';
import './App.css';
import useStore from './templates/store/store';

function App() {
  const { init, testPoke } = useStore();

  useEffect(() => {
    init()
    testPoke()
    console.log(`Init would happen here`);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="App">
      <header className="App-header">
        <p>
          uAMM
        </p>
      </header>
    </div>
  );
}

export default App;
