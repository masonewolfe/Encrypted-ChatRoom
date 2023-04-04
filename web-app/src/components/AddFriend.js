import React from 'react'
import { Form, Button } from 'react-bootstrap'

export default function AddFriend() {
    return (
        <>
            <Form className="d-flex py-3">
                <Form.Control type="search" placeholder="Enter jid" className="me-2" aria-label="Search" />
                <Button variant="outline-light">Search</Button>
            </Form>
        </>
    )
}
