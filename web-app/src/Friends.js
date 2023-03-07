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
                <div className='border my-3 py-3'>
                    <Container>
                        <span className='m-3'>{props.jid}</span>
                        <span className='m-3 '>{props.presence}</span>
                    </Container>
                </div>
            </>
        )
    })
    return (
        <>
            <div className='border text-center mt-3 py-3 bg-light'>Friends List</div>
            {friendsList}
        </>
    )
}
