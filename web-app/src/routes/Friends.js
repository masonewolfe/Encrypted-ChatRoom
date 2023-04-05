import React from 'react'
import { Button, Col, Container, Form, Row } from 'react-bootstrap'
import NavBar from '../components/NavBar'
import SendMessage from '../components/SendMessage'
import AddFriend from '../components/AddFriend'

export default function Friends() {

    const friends = [
        {
            id: 0,
            jid: "joey@selfdestructim.com",
            presence: "online"
        },
        {
            id: 1,
            jid: "mason@selfdestructim.com",
            presence: "online"
        },
        {
            id: 2,
            jid: "jordan@selfdestructim.com",
            presence: "online"
        },
        {
            id: 3,
            jid: "dylan@selfdestructim.com",
            presence: "online"
        },
        {
            id: 4,
            jid: "sydney@selfdestructim.com",
            presence: "online"
        },
        {
            id: 5,
            jid: "johnwick@selfdestructim.com",
            presence: "online"
        },
        {
            id: 6,
            jid: "guy@selfdestructim.com",
            presence: "online"
        }
    ]
    const friendsList = friends.map((props) => {
        return (
            <>
                <div className='border py-5'>
                    <Container className='text-light'>
                        <Row className='px-md-3 px-lg-5'>
                            <Col className='col-xl-3'>
                                <img height={30} width={30} alt='Anonynmous mask profile' src="https://resume-website-bucket.s3.us-east-2.amazonaws.com/anonymous-mask.png" ></img>
                                {props.jid}
                            </Col>
                            <Col className='col-6 col-xl-3'>{props.presence}</Col>
                            <Col className='col-6 col-xl-3'>
                                <Button variant='outline-light'>Message</Button>
                            </Col>
                            <Col className='col-6 col-xl-3'>
                                <Button variant='light'>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                        <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z" />
                                        <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z" />
                                    </svg>
                                </Button>
                            </Col>
                        </Row>
                    </Container>
                </div>
            </>
        )
    })
    return (
        <>
            <NavBar brand='Friends' />
            <div className='bg-dark'>
                <Container>
                    {/* <h2 className='text-light pt-3'>Friends</h2> */}
                    <Row>
                        <Col className='col-12 col-md-4 py-3'>
                            <Button variant='outline-light'>
                                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-person-add" viewBox="0 0 16 16">
                                    <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Zm.5-5v1h1a.5.5 0 0 1 0 1h-1v1a.5.5 0 0 1-1 0v-1h-1a.5.5 0 0 1 0-1h1v-1a.5.5 0 0 1 1 0Zm-2-6a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM8 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z" />
                                    <path d="M8.256 14a4.474 4.474 0 0 1-.229-1.004H3c.001-.246.154-.986.832-1.664C4.484 10.68 5.711 10 8 10c.26 0 .507.009.74.025.226-.341.496-.65.804-.918C9.077 9.038 8.564 9 8 9c-5 0-6 3-6 4s1 1 1 1h5.256Z" />
                                </svg>
                                <span className='ms-1'>Add a friend</span>
                            </Button>
                        </Col>
                        <Col className='col-12 col-md-8 py-3'>
                            <Form className="d-flex">
                                <Form.Control type="search" placeholder="Search friends list" className="me-2" aria-label="Search" />
                                <Button variant="outline-light">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                                        <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z" />
                                    </svg>
                                </Button>
                            </Form>
                        </Col>
                    </Row>
                    <div className='pb-5'>{friendsList}</div>
                </Container>
            </div>
        </>
    )
}
