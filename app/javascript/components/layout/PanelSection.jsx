import React from "react";
import { Link } from "react-router-dom";

const PanelButton = ({
    children,
    className = "btn btn-lg custom-button",
    role = "button",
    to }) => (
  <Link
    to={to}
    className={className}
    role={role}
  >
    {children}
  </Link>
)

const PanelHeading = ({ children, className = "display-4" }) => (
  <h1 className={className}>{children}</h1>
)

const PanelParagraph = ({ children, className = "lead" }) => (
  <p className="lead">
    {children}
  </p>
)

const PanelSection = (props) => (
  <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
    <div className="mt-4 p-5 bg-transparent rounded">
      {props.children}
    </div>
  </div>
)

const PanelTextDivider = (className = "my-4") => (
  <hr className={className} />
)

export { PanelButton, PanelHeading, PanelParagraph, PanelSection, PanelTextDivider };
