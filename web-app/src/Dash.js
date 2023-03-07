import React from 'react'
import { Container } from 'react-bootstrap'
import SendMessage from './SendMessage'
import Friends from './Friends'

export default function Dash() {

    return (
        <div className='min-vh-100'>
            <Container className='border'>
                <Friends></Friends>
                <div className='border text-center mt-3 py-3 bg-light'>Send a message to johnwick@cipher.com</div>
                <div style={{height: "700px"}}></div>
                <div className="input-group mb-3 pt-3">
                    <input type="text" className="form-control" placeholder="Enter text" aria-label="Message" aria-describedby="button-addon2"></input>
                    <SendMessage></SendMessage>
                </div>
            </Container>
        </div>
    )
}
