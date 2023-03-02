import React from 'react'
import { Container } from 'react-bootstrap'

export default function Dash() {

    return (
        <div className='min-vh-100'>
            <Container className='border'>
                <div className='border text-center mt-3 py-3 bg-light'>Send a message to joey@selfdestructim.com</div>
                <div style={{height: "700px"}}></div>
                <div className="input-group mb-3 pt-3">
                    <input type="text" className="form-control" placeholder="Enter text" aria-label="Message" aria-describedby="button-addon2"></input>
                    <button className="btn btn-dark" type="button" id="button-addon2">
                        Send
                    </button>
                </div>
            </Container>
        </div>
    )
}
