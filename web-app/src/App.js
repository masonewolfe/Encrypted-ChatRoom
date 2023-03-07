import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Landing from './routes/Landing.js';
import LogIn from './routes/LogIn.js';
import SignUp from './routes/SignUp.js';
import Home from './routes/Home.js';
import Friends from './routes/Friends.js';

function App() {

  return (
    <Router>
      <Routes>
        <Route exact path='/' element={<Landing />} />
        <Route path='/login' element={<LogIn />} />
        <Route path='/signup' element={<SignUp />} />
        <Route path='/home' element={<Home/>} />
        <Route path='/friends' element={<Friends/>} />
      </Routes>
    </Router>
  );
}

export default App;
