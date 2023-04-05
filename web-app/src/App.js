import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Landing from './routes/Landing.js';
import LogIn from './routes/LogIn.js';
import Register from './routes/Register.js';
import Messages from './routes/Messages.js';
import Friends from './routes/Friends.js';

function App() {

  return (
    <Router>
      <Routes>
        <Route exact path='/' element={<Landing />} />
        <Route path='/login' element={<LogIn />} />
        <Route path='/register' element={<Register />} />
        <Route path='/messages' element={<Messages />} />
        <Route path='/friends' element={<Friends/>} />
      </Routes>
    </Router>
  );
}

export default App;
