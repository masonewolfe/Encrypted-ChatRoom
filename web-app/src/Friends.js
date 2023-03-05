import React from 'react'
import { Container } from 'react-bootstrap'

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
        }
    ]
    const friendsList = friends.map((props) => {
        return (
            <>
                <Container className='border'>
                    <div>{props.jid} {props.presence}</div>
                </Container>
            </>
        )
    })
    return (
        <div className='min-vh-100'>
            <Container className='border'>
                <Friends></Friends>
                <div className='border text-center mt-3 py-3 bg-light'>Friends List</div>
                <div style={{ height: "700px" }}></div>
                {friendsList}
            </Container>
        </div>
    )
}
