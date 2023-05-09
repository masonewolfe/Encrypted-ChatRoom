const express = require("express");
const cors = require("cors");
const app = express();
const port = 4000;
const xmpp = require("simple-xmpp");

// const simplexmpp = import("./xmppController.js");

// app.use("/api", router);

// app.get("/", (req, res) => {
//   console.log("get request handled");
//   res.send("SERVER WORKING");
// });

app.use(cors());

app.post("/connect", (req, res) => {
  console.log("post request handled");
  simplexmpp.run();
  res.send("connected");
});
app.post("/send", (req, res) => {
  send(req.body.to, req.body.message);
  //   console.log("post request send message");
  res.send("post request send message");
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}.`);
});

xmpp.on("online", (data) => {
  app.get("/online", (req, res) => {
    res.send("you are now online");
  });
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

function send(to, message) {
  xmpp.send(to, message);
  console.log("Message sent.");
}

// function send() {
//   xmpp.send("johnwick@cipher.com", "Hello from nodejs!");
//   console.log("Message sent.");
// }

xmpp.connect({
  jid: "joey@cipher.com",
  password: "password",
  host: "3.91.204.251",
  port: 5222,
});
