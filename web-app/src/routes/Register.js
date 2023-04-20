import React from "react";
import NavBar from "../components/NavBar.js";
import { Button, Col, Container, Form, FormLabel, Row } from "react-bootstrap";

export default function Register() {
  async function checkAccount() {
    fetch("http://3.91.204.251:5281/api/check_account", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user: "joeybot",
        host: "cipher.com",
      }),
    })
      .then((response) => response.json())
      .then((response) => console.log(JSON.stringify(response)));
  }

  function registerAccount() {
    fetch("http://3.91.204.251:5281/api/register", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user: "joeybot",
        host: "cipher.com",
        password: "password",
      }),
    })
      .then((response) => response.json())
      .then((response) => console.log(JSON.stringify(response)));
  }

  return (
    <>
      <NavBar brand="Register" />
      <div className="bg-dark">
        <Container className="py-5 text-light text-center">
          <Form onSubmit={() => checkAccount()}>
            <Form.Group className="my-3 py-3">
              <Form.Label>
                <h2>Cipher Id</h2>
              </Form.Label>
              <Form.Control type="email" placeholder="Enter cipher id" />
              <Form.Text className="text-muted">
                Cipher Id's are written in the format xxxxx@cipher.com
              </Form.Text>
            </Form.Group>
            <Form.Group className="my-3 py-3">
              <Form.Label>
                <h2>Password</h2>
              </Form.Label>
              <Form.Control type="password" placeholder="Enter password" />
            </Form.Group>
            <Form.Group className="my-3 py-3">
              <Form.Label>
                <h2>Confirm password</h2>
              </Form.Label>
              <Form.Control type="password" placeholder="Re-enter password" />
            </Form.Group>
            <Button
              className="btn btn-lg mb-3"
              variant="outline-light"
              type="submit"
            >
              Create account
            </Button>
          </Form>
          <div className="pt-5 pb-3">Already have an account with cipher?</div>
          <a href="/login">
            <Button variant="outline-light">Log in here</Button>
          </a>
          <div className="py-5">
            Break free from the grips of big tech companies, and protect what's
            important to you once and for all.
          </div>
        </Container>
      </div>
    </>
  );
}
