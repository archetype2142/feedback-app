import { useState, useEffect } from 'react';
import { fetchFeedback } from '../services/feedbackService';

/**
 * @typedef {Object} Reply
 * @property {string} id
 * @property {string} content
 * @property {string} created_at
 * @property {'user' | 'assistant'} sender_type
 */

/**
 * @typedef {Object} Feedback
 * @property {string} id
 * @property {Reply[]} replies
 */

const useFeedbackState = () => {
  const [currentFeedback, setCurrentFeedback] = useState(null);

  // Initialize feedback from localStorage
  useEffect(() => {
    const savedFeedbackId = localStorage.getItem('currentFeedbackId');
    if (savedFeedbackId) {
      handleFetchFeedback(savedFeedbackId);
    }
  }, []);

  const handleFetchFeedback = async (feedbackId) => {
    try {
      const data = await fetchFeedback(feedbackId);
      setCurrentFeedback(data);
      localStorage.setItem('currentFeedbackId', feedbackId);
    } catch (error) {
      localStorage.removeItem('currentFeedbackId');
      console.error('Error fetching feedback:', error);
      throw error; // Re-throw to allow handling by caller
    }
  };

  const updateFeedback = (newFeedback) => {
    if (!newFeedback) {
      clearFeedback();
      return;
    }
    
    setCurrentFeedback(newFeedback);
    if (newFeedback.id) {
      localStorage.setItem('currentFeedbackId', newFeedback.id);
    }
  };

  const clearFeedback = () => {
    setCurrentFeedback(null);
    localStorage.removeItem('currentFeedbackId');
  };

  return {
    currentFeedback,
    handleFetchFeedback,
    setCurrentFeedback: updateFeedback,
    clearFeedback,
  };
};

export default useFeedbackState;
