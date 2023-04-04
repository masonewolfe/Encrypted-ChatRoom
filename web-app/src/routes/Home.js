import React from 'react'
import NavBar from '../components/NavBar.js';
import Dash from '../components/Dash.js';
import { Container } from 'react-bootstrap';

export default function Home() {
  return (
    <>
      <NavBar brand='Home'/>
      <div className='bg-dark'>
        <Dash />
      </div>
    </>
  )
}
