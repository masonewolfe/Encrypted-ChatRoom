import React from 'react'

export default function SendMessage() {

  async function send() {

    const response = await fetch('3.142.122.67:3000');
    const json = await response.json();
    console.log(json);

    // fetch(
    //   'https:52.188.65.46', {
    //   method: 'POST',
    //   headers: {
    //     'Accept': 'application/json',
    //     'Content-Type': 'application/json'
    //   },
    //   body: JSON.stringify({

    //     "type": "headline",
    //     "from": "joey@selfdestructim.com",
    //     "to": "mason@selfdestructim.com",
    //     "subject": "test",
    //     "body": "Did you get my message?"
    //   })
    // }
    // ).then(response => response.json()).then(response => console.log(JSON.stringify(response)))

  }
  return (
    <>
      <button className='btn btn-dark' type='button' onClick={() => {send()}}>Send</button>
    </>
  )
}