import Dash from "./Dash.js";
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import { useState } from "react";

function App() {

  // const [display, setDisplay] = useState(false)
  return (
    <>

      <Navbar bg="light" expand="lg">
        <Container>
          <Navbar.Brand href="#home">Cipher</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <Nav.Link>Friends</Nav.Link>
              <Nav.Link href="#">Groupchats</Nav.Link>
              <Nav.Link href="#">Blocked</Nav.Link>
              <Nav.Link className='ms-10' href="#">Profile</Nav.Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
      {/* {display && <Dash></Dash>} */}
      <Dash></Dash>
    </>
  );
}

export default App;
