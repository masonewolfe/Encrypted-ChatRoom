const xmpp = require("simple-xmpp");

xmpp.on("online", data => {

    console.log('Welcome ${}')
    send();
})

function send() {
    xmpp.send("mason@selfdestructim.com", "What is up my guy?")
}

xmpp.on("chat", (from, messgae) => {
    console.log('You have a new message!')
    console.log('${from} said ${message}')
})

xmpp.connect({
    "jid": "joey@selfdestructim.com",
    "password": "password",
    "host": "52.188.65.46",
    "port": 5222
})