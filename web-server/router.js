const express = require("express");
const router = express.Router();

router.post("/send", function (req, res) {
  res.send("send api call");
});

router.post("/register", function (req, res) {
  res.send("register api call");
});

module.exports = router;