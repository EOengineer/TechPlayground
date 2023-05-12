import React from "react";
import { Container, Button } from "reactstrap";
import { 
  PanelButton, 
  PanelHeading, 
  PanelParagraph,
  PanelSection,
  PanelTextDivider
 } from "./layout/PanelSection";

export default () => (
  <PanelSection>
    <Container fluid className="secondary-color"> 
      <PanelHeading>React Projects</PanelHeading>
      <PanelParagraph>
        This page is rendered using ReactJS.
      </PanelParagraph>

      <PanelTextDivider />

      <PanelButton
        to={"/react/projects"}
      >
        View React Projects
      </PanelButton>
    </Container>
  </PanelSection>
)