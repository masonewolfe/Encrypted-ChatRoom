import React from 'react'

export default function SendMessage() {

  async function send() {

    // fetch(
    //   'http://3.91.204.251:5281/api/get_offline_count', {
    //   method: 'POST',
    //   body: {
    //     "user": "joey@cipher.com",
    //     "server": "3.91.204.251"
    //   }
    // }
    // ).then(function (response) { console.log(response) })

    // fetch(
    //   'http://3.91.204.251:5281/api/send_message', {
    //   method: 'POST',
    //   headers: {
    //     'Accept': 'application/json',
    //     'Content-Type': 'application/json'
    //   },
    //   body: JSON.stringify({

    //     "type": "headline",
    //     "from": "joey@cipher.com",
    //     "to": "mason@cipher.com",
    //     "subject": "test",
    //     "body": "Did you get my message?"
    //   })
    // }
    // ).then(response => response.json()).then(response => console.log(JSON.stringify(response)))

    fetch(
      'http://3.91.204.251:5281/api/send_stanza', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({

        "from": "joey@cipher.com",
        "to": "mason@cipher.com",
        "stanza": "<message><ext attr='value'/><body>this is a stanza</body></message>"
      })
    }
    ).then(response => response.json()).then(response => console.log(JSON.stringify(response)))

  }
  // function sendWithServer() {
  //   fetch(
  //     'http://localhost:4000/send', {
  //     method: 'POST',
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json'
  //     },
  //     body: JSON.stringify({

  //       "to": "joey@cipher.com",
  //       "message": "message from custom api"
  //     })
  //   }
  //   )
  // }
  return (
    <>
      <button className='btn btn-primary' type='button' onClick={() => { send() }}>Message</button>
    </>
  )
}