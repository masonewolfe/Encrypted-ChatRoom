import React from 'react'
import NavBar from '../components/NavBar.js';
import { Button, Col, Container, Row } from 'react-bootstrap';

export default function Landing() {
  return (
    <>
      <NavBar brand='Welcome to Cipher' />
      <div className=''>
        <Container className='pt-3'>
          <Row className='py-3 text-center'>
            <Col>
              <a href='/register'><Button variant='outline-dark'>Create an account now</Button></a>
            </Col>
            <Col>
              <a href='/login'><Button variant='outline-dark'>Log In</Button></a>
            </Col>
          </Row>
          <Row className='py-3 text-center'>
            <Col className='col-3'>
              <img className='img-fluid' width="250" height="250" alt='locked shield logo' src="https://resume-website-bucket.s3.us-east-2.amazonaws.com/shield-lock.svg" ></img>
            </Col>
            <Col className='col-6 my-auto'><h2>Why choose Cipher?</h2></Col>
            <Col className='col-3'>
              <img className='img-fluid' width="250" height="250" alt='locked shield logo' src="https://resume-website-bucket.s3.us-east-2.amazonaws.com/shield-lock.svg" ></img>
            </Col>
          </Row>
          <Row className='py-5 border'>
            <Col className='col-8 justify-content-end'>The only two people that can view messages sent on Cipher are the sender and receiver. We use asymmetric encryption of all messages
              meaning when you send a message, it is automatically encrypted using the recipient's public key, and then only they posses the private key to de-<b>Cipher</b> the message.
            </Col>
            <Col className='col-4 text-center'>
              <h3>End-to-End Encrypted</h3>
              <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" className="bi bi-lock" viewBox="0 0 16 16">
                <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2zM5 8h6a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z" />
              </svg>
            </Col>
          </Row>
          <Row className='py-5 border'>
            <Col className='col-4 text-center'>
              <h3>Non-Persitent Messages</h3>
              <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" className="bi bi-trash3" viewBox="0 0 16 16">
                <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5ZM11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H2.506a.58.58 0 0 0-.01 0H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1h-.995a.59.59 0 0 0-.01 0H11Zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5h9.916Zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47ZM8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5Z" />
              </svg>
            </Col>
            <Col className='col-8'>Your message, once read by the recipient, will be forever deleted off of their device, as well as our server. So, not only
              is it impossible for a spy to read your private message, they would only even have a the smallest window of opportunity. Even if the message is not read
              our system will auto delete the message within 48 hours.</Col>
          </Row>
          <Row className='py-5 border'>
            <Col className='col-8'>
              Send messages instantly to anyone, anywhere on the globe. Cipher messaging is the fastest and most convenient full privacy application on the market.
              We pick up the other guy's slack, so you can have the peace of mind that you will always be in touch with those you care about, without any snooping.
            </Col>
            <Col className='col-4 text-center'>
              <h3>Instant Global Connection</h3>
              <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" class="bi bi-globe" viewBox="0 0 16 16">
                <path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm7.5-6.923c-.67.204-1.335.82-1.887 1.855A7.97 7.97 0 0 0 5.145 4H7.5V1.077zM4.09 4a9.267 9.267 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.025 7.025 0 0 0 2.255 4H4.09zm-.582 3.5c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5h2.49zM4.847 5a12.5 12.5 0 0 0-.338 2.5H7.5V5H4.847zM8.5 5v2.5h2.99a12.495 12.495 0 0 0-.337-2.5H8.5zM4.51 8.5a12.5 12.5 0 0 0 .337 2.5H7.5V8.5H4.51zm3.99 0V11h2.653c.187-.765.306-1.608.338-2.5H8.5zM5.145 12c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12H5.145zm.182 2.472a6.696 6.696 0 0 1-.597-.933A9.268 9.268 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM3.82 11a13.652 13.652 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5H3.82zm6.853 3.472A7.024 7.024 0 0 0 13.745 12H11.91a9.27 9.27 0 0 1-.64 1.539 6.688 6.688 0 0 1-.597.933zM8.5 12v2.923c.67-.204 1.335-.82 1.887-1.855.173-.324.33-.682.468-1.068H8.5zm3.68-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm2.802-3.5a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5h2.49zM11.27 2.461c.247.464.462.98.64 1.539h1.835a7.024 7.024 0 0 0-3.072-2.472c.218.284.418.598.597.933zM10.855 4a7.966 7.966 0 0 0-.468-1.068C9.835 1.897 9.17 1.282 8.5 1.077V4h2.355z" />
              </svg>
            </Col>
          </Row>
          <Row className='py-5 border'>
            <Col className='col-4 text-center'>
              <h3>Now supports groupchats!</h3>
              <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16">
                <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8Zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022ZM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816ZM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0Zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z" />
              </svg>
            </Col>
            <Col className='col-8'>
              The all-new groupchat feature allows you to message the entire family at once, or create groups with friends or strangers about similar topics of interest.
            </Col>
          </Row>
        </Container>
      </div>
    </>
  )
}
