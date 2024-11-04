import { useState, useEffect, useCallback } from 'react';
import { fetchFeedback } from '../services/feedbackService';
import debounce from 'lodash/debounce'; // Add this to your dependencies if not already present

const DEBOUNCE_DELAY = 500; // Milliseconds to wait before making API call

const useFeedbackState = () => {
  const [currentFeedback, setCurrentFeedback] = useState(null);
  const [pendingRequest, setPendingRequest] = useState(null);

  // Debounced fetch function
  const debouncedFetch = useCallback(
    debounce(async (feedbackId) => {
      try {
        const data = await fetchFeedback(feedbackId);
        setCurrentFeedback(data);
        localStorage.setItem('currentFeedbackId', feedbackId);
        setPendingRequest(null);
      } catch (error) {
        localStorage.removeItem('currentFeedbackId');
        console.error('Error fetching feedback:', error);
        setPendingRequest(null);
      }
    }, DEBOUNCE_DELAY),
    []
  );

  // Cancel any pending debounced calls on unmount
  useEffect(() => {
    return () => {
      debouncedFetch.cancel();
    };
  }, [debouncedFetch]);

  const handleFetchFeedback = async (feedbackId) => {
    // Cancel any pending requests
    if (pendingRequest) {
      debouncedFetch.cancel();
    }

    setPendingRequest(feedbackId);
    debouncedFetch(feedbackId);
  };

  // Initialize from localStorage
  useEffect(() => {
    const savedFeedbackId = localStorage.getItem('currentFeedbackId');
    if (savedFeedbackId) {
      handleFetchFeedback(savedFeedbackId);
    }
  }, []);

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
    debouncedFetch.cancel(); // Cancel any pending requests
  };

  const addReply = (reply) => {
    setCurrentFeedback(prev => {
      if (!prev) return null;
      return {
        ...prev,
        replies: [...(prev.replies || []), reply]
      };
    });
  };

  const updateReply = (replyId, updatedReply) => {
    setCurrentFeedback(prev => {
      if (!prev?.replies) return prev;
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
      if (!prev?.replies) return prev;
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
    handleFetchFeedback,
    setCurrentFeedback: updateFeedback,
    clearFeedback,
    addReply,
    updateReply,
    removeReply,
    addTemporaryReply,
    replaceTemporaryReply,
    isPending: !!pendingRequest
  };
};

export default useFeedbackState;
