import React from 'react'

export default function SendMessage() {

  function send() {

    fetch(
      'https:52.188.65.46', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({

        "type": "headline",
        "from": "joey@selfdestructim.com",
        "to": "mason@selfdestructim.com",
        "subject": "test",
        "body": "Did you get my message?"
      })
    }
    ).then(response => response.json()).then(response => console.log(JSON.stringify(response)))

  }
  return (
    <div>
      <button onClick={send() && console.log("tried to send msg")}>Send jordan a message</button>
    </div>
  )
}