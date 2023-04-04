import React from 'react'

export default function RetrieveMessages() {

    async function retrieve() {

        fetch(
            '44.212.55.214:5281/api/send_message', {
            method: 'POST',
            mode: 'cors',
            body: JSON.stringify({

                "type": "headline",
                "from": "joey@cipher.com",
                "to": "mason@cipher.com",
                "subject": "test",
                "body": "Did you get my message?"
            })
        })
    }
    return (
        <>

        </>
    )
}
