import { getCSRFToken } from '../utils/csrf';

export const fetchFeedback = async (feedbackId) => {
  const response = await fetch(`/api/feedbacks/${feedbackId}`);
  if (!response.ok) throw new Error('Failed to fetch feedback');
  return response.json();
};

export const createFeedback = async (content) => {
  const response = await fetch('/api/feedbacks', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': getCSRFToken(),
    },
    body: JSON.stringify({ feedback: { content } }),
  });
  if (!response.ok) {
    // Attempt to parse the response body as JSON
    const errorDetails = await response.json().catch(() => null); // Handle cases where body is not JSON
    console.error("Error details:", errorDetails || response.statusText);
    throw new Error(errorDetails?.errors.base[0] || 'Failed to create feedback');
  }
  return response.json();
};

export const createReply = async (feedbackId, content) => {
  const response = await fetch(`/api/feedbacks/${feedbackId}/replies`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': getCSRFToken(),
    },
    body: JSON.stringify({ reply: { content } }),
  });
  if (!response.ok) {
    // Attempt to parse the response body as JSON
    const errorDetails = await response.json().catch(() => null); // Handle cases where body is not JSON
    console.error("Error details:", errorDetails || response.statusText);
    throw new Error(errorDetails?.errors.base[0] || 'Failed to create reply');
  }

  return response.json();
};
