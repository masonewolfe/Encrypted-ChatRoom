import Button from 'react-bootstrap/Button';
import React from 'react'
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';
import Form from 'react-bootstrap/Form';
import Offcanvas from 'react-bootstrap/Offcanvas';

/* 
    Basic Navbar from React Bootstrap component library
**/
export default function NavBar(props) {

    const expand = false
    return (
        <>
            <Navbar key={expand} bg="dark" variant='dark' sticky='top' expand={expand} className='py-3'>
                <Container fluid>
                    <Navbar.Brand>{props.brand}</Navbar.Brand>
                    <Navbar.Toggle aria-controls={`offcanvasNavbar-expand-${expand}`} />
                    <Navbar.Offcanvas
                        id={`offcanvasNavbar-expand-${expand}`}
                        aria-labelledby={`offcanvasNavbarLabel-expand-${expand}`}
                        placement="end"
                    >
                        <Offcanvas.Header closeButton>
                            <Offcanvas.Title id={`offcanvasNavbarLabel-expand-${expand}`}>
                                Cipher
                            </Offcanvas.Title>
                        </Offcanvas.Header>
                        <Offcanvas.Body>
                            <Nav className="justify-content-end flex-grow-1 pe-3">
                                <Nav.Link href='/home'>Home</Nav.Link>
                                <Nav.Link href='/friends'>Friends</Nav.Link>
                                <Nav.Link href='/groups'>Groupchats</Nav.Link>
                                <Nav.Link href="/profile">Profile</Nav.Link>
                            </Nav>
                        </Offcanvas.Body>
                    </Navbar.Offcanvas>
                </Container>
            </Navbar>
            {/* // <Navbar sticky="top" bg="dark" variant='dark' expand="sm">
          //     <Container>
          //         <Navbar.Brand>{props.brand}</Navbar.Brand>
          //         <Navbar.Toggle aria-controls="basic-navbar-nav" />
          //         <Navbar.Collapse id="basic-navbar-nav">
          //             <Nav className="me-auto">
          //                 <Nav.Link href='/home'>Home</Nav.Link>
          //                 <Nav.Link href='/friends'>Friends</Nav.Link>
          //                 <Nav.Link href='/groups'>Groupchats</Nav.Link>
          //                 <Nav.Link className='ms-10' href="#">Profile</Nav.Link>
          //             </Nav>
          //         </Navbar.Collapse>
          //     </Container>
          // </Navbar> */}
        </>
    );
}