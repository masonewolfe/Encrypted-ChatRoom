import React from 'react'
import NavBar from '../components/NavBar.js';
import { Button, Col, Container, Row } from 'react-bootstrap';

export default function Messages() {

  const mes = [
    {
      "key": 0,
      "from": "johnwick@cipher.com",
      "body": "Whats good homie"
    },
    {
      "key": 1,
      "from": "mason@cipher.com",
      "body": "Whats good g"
    },
    {
      "key": 2,
      "from": "mason@cipher.com",
      "body": "Brother man, good evening"
    },
    {
      "key": 3,
      "from": "johnwick@cipher.com",
      "body": "you finish the hw?"
    },
    {
      "key": 4,
      "from": "jordan@cipher.com",
      "body": "cipherrrrrrrrr"
    },
  ]
  const messagesList = mes.map((props) => {
    return (
      <>
        <div className='border py-5'>
          <Container className='text-light'>
            <Row className='px-md-3 px-lg-5'>
              <Col className=''>
                <img height={30} width={30} alt='Anonynmous mask profile' src="https://resume-website-bucket.s3.us-east-2.amazonaws.com/anonymous-mask.png" ></img>
                {props.from}
              </Col>
            </Row>
          </Container>
        </div>
      </>
    )
  })
  return (
    <>
      <NavBar brand='Messages' />
      <div className='bg-dark'>
        <Container>
          <Row>
            <Col className='col-12 col-md-4 py-3'>
              <Button variant='outline-light'>
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-chat-left" viewBox="0 0 16 16">
                  <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z" />
                  <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z" />
                </svg>
                <span className='ms-1'>New message</span>
              </Button>
            </Col>
          </Row>
          <div className='pb-5'>{messagesList}</div>
        </Container>
      </div>
    </>
  )
}
