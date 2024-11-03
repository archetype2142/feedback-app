import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './components/App';

document.addEventListener('DOMContentLoaded', () => {
  const domNode = document.getElementById('homepage');
  const root = createRoot(domNode);

  root.render(<App />);
});
