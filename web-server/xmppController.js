const xmpp = require("simple-xmpp");

const simplexmpp = () => {

    function run() {

        xmpp.on("online", (data) => {
          console.log("Welcome " + data.jid.user);
          send();
        });
        
        xmpp.on("close", (data) => {
          console.log("Goodbye " + data.jid.user);
          xmpp.disconnect();
        });
        
        xmpp.on("error", (err) => {
          console.log(err);
        });
        
        xmpp.on("chat", (from, message) => {
          console.log("New message!");
          console.log("from %s...\n%s", from, message);
        });
        
        xmpp.on("chatstate", (from, state) => {
          console.log("%s is now %s", from, state);
        });
        
        function send() {
          xmpp.send("johnwick@cipher.com", "Hello from nodejs!");
          console.log("Message sent.");
        }
        
        xmpp.connect({
          jid: "joey@cipher.com",
          password: "password",
          host: "3.91.204.251",
          port: 5222,
        });
    }
}

module.exports = simplexmpp;