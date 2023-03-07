import React from 'react'
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import { Link, useNavigate } from 'react-router-dom';

/* 
    Basic Navbar from React Bootstrap component library
**/
export default function NavBar() {
    return (
        <Navbar bg="light" expand="lg">
            <Container>
                <Navbar.Brand>Cipher</Navbar.Brand>
                <Navbar.Toggle aria-controls="basic-navbar-nav" />
                <Navbar.Collapse id="basic-navbar-nav">
                    <Nav className="me-auto">
                        <Nav.Link href='/home'>Home</Nav.Link>
                        <Nav.Link href='/friends'>Friends</Nav.Link>
                        <Nav.Link href='/groups'>Groupchats</Nav.Link>
                        <Nav.Link href='/blocked'>Blocked</Nav.Link>
                        <Nav.Link className='ms-10' href="#">Profile</Nav.Link>
                    </Nav>
                </Navbar.Collapse>
            </Container>
        </Navbar>
    );
}