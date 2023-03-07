import React from 'react'

export default function SendMessage() {

  async function send() {

    // const response = await fetch('44.212.55.214:5281/api/send_message');
    // const json = await response.json();
    // console.log(response);

    fetch(
      '44.212.55.214:5281/api/send_message', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({

        "type": "headline",
        "from": "joey@cipher.com",
        "to": "johnwick@cipher.com",
        "subject": "test",
        "body": "Did you get my message?"
      })
    }
    ).then(response => response.json()).then(response => console.log(JSON.stringify(response)))

  }
  return (
    <>
      <button className='btn btn-dark' type='button' onClick={() => { send() }}>Send</button>
    </>
  )
}