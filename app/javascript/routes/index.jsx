import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import ReactHome from "../components/ReactHome";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<ReactHome />} />
    </Routes>
  </Router>
);