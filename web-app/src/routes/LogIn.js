import React, { useRef, useState } from "react";
import NavBar from "../components/NavBar.js";
import { Alert, Button, Container, Form } from "react-bootstrap";
import { useUser } from "../UserContext.js";
import { useNavigate } from "react-router-dom";

export default function LogIn() {
  const jidRef = useRef();
  const passwordRef = useRef();
  const { login } = useUser;
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleSubmit(e) {
    e.preventDefault();

    try {
      setError("");
      setLoading(true);
      await login(jidRef.current.value, passwordRef.current.value);
      navigate('/messages');
    } catch {
      setError("Log in failed");
    }
    setLoading(false);
  }

  return (
    <>
      <NavBar brand="Log In" />
      <div className="">
        <Container className="py-5 text-center">
          {error && <Alert variant="danger">{error}</Alert>}
          <Form onSubmit={handleSubmit}>
            <Form.Group className="my-3 py-5" controlId="formBasicEmail">
              <Form.Label>
                <h2>Cipher Id</h2>
              </Form.Label>
              <Form.Control type="email" ref={jidRef} placeholder="Enter cipher id" required/>
              <Form.Text className="text-muted">
                Cipher Id's are written in the format xxxxx@cipher.com
              </Form.Text>
            </Form.Group>
            <Form.Group className="my-3 py-5" controlId="formBasicPassword">
              <Form.Label>
                <h2>Password</h2>
              </Form.Label>
              <Form.Control type="password" ref={passwordRef} placeholder="Enter password" required/>
            </Form.Group>
            <Button
              disabled={loading}
              className="btn btn-lg mb-5"
              variant="outline-dark"
              type="submit"
            >
              Log In
            </Button>
          </Form>
          <div className="pt-5 pb-3">Don't have an account with cipher?</div>
          <a href="/register">
            <Button variant="outline-dark">Register here</Button>
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
