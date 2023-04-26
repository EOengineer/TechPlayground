import React from "react";
import { Link } from "react-router-dom";
import { Container, Button } from "reactstrap";

export default () => (
  <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
    <div className="mt-4 p-5 bg-transparent rounded">
      <Container fluid className="secondary-color"> 
      <h1 className="display-4">React Homepage</h1>
           <p className="lead">
             This page is rendered using ReactJS.
           </p>
           <hr className="my-4" />
           <Link
            to="/react/projects"
            className="btn btn-lg custom-button"
            role="button"
          >
            View React Projects
          </Link>
      </Container>
    </div>
  </div>
)