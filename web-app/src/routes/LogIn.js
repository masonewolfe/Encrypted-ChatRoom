import React from 'react'
import NavBar from '../components/NavBar.js';
import { Button, Col, Container, Form, Row } from 'react-bootstrap';

export default function LogIn() {

  // function handleSubmit() {
  //   const data = new FormData()
  //   console.log(data.formBasicPassword);
  //   XmppControllerConnect(data.formBasicPassword)
  // }
  return (
    <>
      <NavBar brand="Log In" />
      <div className='bg-dark'>
        <Container className='py-5 text-light text-center'>
          <Form >
            <Form.Group className="my-3 py-5" controlId="formBasicEmail">
              <Form.Label><h2>Cipher Id</h2></Form.Label>
              <Form.Control type="email" placeholder="Enter cipher id" />
              <Form.Text className="text-muted">
                Cipher Id's are written in the format xxxxx@cipher.com
              </Form.Text>
            </Form.Group>
            <Form.Group className="my-3 py-5" controlId="formBasicPassword">
              <Form.Label><h2>Password</h2></Form.Label>
              <Form.Control type="password" placeholder="Enter password" />
            </Form.Group>
            <Button className='btn btn-lg mb-5' variant="outline-light" type="submit">
              Log In
            </Button>
          </Form>
          <div className='pt-5 pb-3'>Don't have an account with cipher?</div>
          <a href='/register'><Button variant='outline-light'>Register here</Button></a>
          <div className='py-5'>Break free from the grips of big tech companies, and protect what's important to you once and for all.</div>
        </Container>
      </div>
    </>
  )
}
