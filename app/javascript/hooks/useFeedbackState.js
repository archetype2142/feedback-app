import { useState, useEffect } from 'react';
import { fetchFeedback } from '../services/feedbackService';

const useFeedbackState = () => {
  const [currentFeedback, setCurrentFeedback] = useState(null);

  const handleFetchFeedback = async (feedbackId) => {
    try {
      const data = await fetchFeedback(feedbackId);
      setCurrentFeedback(data);
      localStorage.setItem('currentFeedbackId', feedbackId);
    } catch (error) {
      localStorage.removeItem('currentFeedbackId');
      console.error('Error fetching feedback:', error);
    }
  };

  // Load feedback ID from localStorage on mount
  useEffect(() => {
    const savedFeedbackId = localStorage.getItem('currentFeedbackId');
    if (savedFeedbackId) {
      handleFetchFeedback(savedFeedbackId);
    }
  }, []);

  const updateFeedback = (newFeedback) => {
    setCurrentFeedback(newFeedback);
    if (newFeedback?.id) {
      localStorage.setItem('currentFeedbackId', newFeedback.id);
    }
  };

  const clearFeedback = () => {
    setCurrentFeedback(null);
    localStorage.removeItem('currentFeedbackId');
  };

  const addReply = (reply) => {
    setCurrentFeedback(prev => {
      if (!prev) return prev;
      return {
        ...prev,
        replies: [...prev.replies, reply]
      };
    });
  };

  const updateReply = (replyId, updatedReply) => {
    setCurrentFeedback(prev => {
      if (!prev) return prev;
      return {
        ...prev,
        replies: prev.replies.map(reply => 
          reply.id === replyId ? { ...reply, ...updatedReply } : reply
        )
      };
    });
  };

  const removeReply = (replyId) => {
    setCurrentFeedback(prev => {
      if (!prev) return prev;
      return {
        ...prev,
        replies: prev.replies.filter(reply => reply.id !== replyId)
      };
    });
  };

  const addTemporaryReply = (content, isUser = true) => {
    const tempReply = {
      id: `temp-${Date.now()}`,
      content,
      created_at: new Date().toISOString(),
      sender_type: isUser ? 'user' : 'assistant'
    };
    addReply(tempReply);
    return tempReply.id;
  };

  const replaceTemporaryReply = (tempId, permanentReply) => {
    updateReply(tempId, permanentReply);
  };

  return {
    currentFeedback,
    setCurrentFeedback: updateFeedback,
    handleFetchFeedback,
    clearFeedback,
    addReply,
    updateReply,
    removeReply,
    addTemporaryReply,
    replaceTemporaryReply
  };
};

export default useFeedbackState;
