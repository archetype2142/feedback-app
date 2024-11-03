// app/javascript/routes/index.jsx
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import FeedbackForm from '../components/FeedbackForm';

const AppRoutes = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/feedback" element={<FeedbackForm />} />
        <Route path="/" element={<FeedbackForm />} />
      </Routes>
    </BrowserRouter>
  );
};

export default AppRoutes;
