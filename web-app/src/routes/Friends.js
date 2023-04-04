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
                            <Col className='col-xl-3'>{props.jid}</Col>
                            <Col className='col-6 col-xl-3'>{props.presence}</Col>
                            <Col className='col-6 col-xl-3'>
                                <Button variant='outline-light'>Message</Button>
                            </Col>
                            <Col className='col-6 col-xl-3'>
                                <Button variant='light'>edit</Button>
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
                            <Button variant='outline-light'>Add a friend</Button>
                        </Col>
                        <Col className='col-12 col-md-8 py-3'>
                            <Form className="d-flex">
                                <Form.Control type="search" placeholder="Search friends list" className="me-2" aria-label="Search" />
                                <Button variant="outline-light">Search</Button>
                            </Form>
                        </Col>
                    </Row>
                    <div className='pb-5'>{friendsList}</div>
                </Container>
            </div>
        </>
    )
}
