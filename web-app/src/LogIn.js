const xmpp = require("simple-xmpp");

xmpp.on("online", data => {

    console.log('Welcome ' + data.jid.user)
    send();
})

function send() {
    xmpp.send("sydney@selfdestructim.com", "Hello from nodejs!")
}

xmpp.on("chat", (from, message) => {
    console.log('You have a new message!')
    console.log(from + ' said ' + message)
})

xmpp.connect({
    "jid": "joey@selfdestructim.com",
    "password": "password",
    "host": "52.188.65.46",
    "port": 5222
})