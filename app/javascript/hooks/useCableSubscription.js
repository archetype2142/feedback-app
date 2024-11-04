import { useEffect, useCallback, useRef } from 'react';
import { createConsumer } from '@rails/actioncable';

// Create consumer outside component to prevent recreation
const consumer = createConsumer();

export const useCableSubscription = (feedbackId, setCurrentFeedback) => {
  // Use ref to store subscription
  const subscriptionRef = useRef(null);
  
  // Memoize handleMessage and use ref to avoid recreating subscription
  const handleMessage = useCallback((data) => {
    if (data.type === 'initial_state' || data.type === 'update') {
      setCurrentFeedback(data.feedback);
    }
  }, [setCurrentFeedback]);

  useEffect(() => {
    if (!feedbackId) {
      // Cleanup existing subscription if feedbackId becomes null
      if (subscriptionRef.current) {
        subscriptionRef.current.unsubscribe();
        subscriptionRef.current = null;
      }
      return;
    }

    // Don't create new subscription if we already have one for this feedbackId
    if (subscriptionRef.current?.feedbackId === feedbackId) {
      return;
    }

    // Cleanup previous subscription if exists
    if (subscriptionRef.current) {
      subscriptionRef.current.unsubscribe();
    }

    // Create new subscription
    const subscription = consumer.subscriptions.create(
      { 
        channel: 'FeedbackChannel', 
        feedback_id: feedbackId 
      },
      { 
        received: handleMessage,
        // Add connection handlers for debugging if needed
        connected() {
          console.log(`Connected to feedback ${feedbackId}`);
        },
        disconnected() {
          console.log(`Disconnected from feedback ${feedbackId}`);
        }
      }
    );

    // Store feedbackId with subscription for comparison
    subscription.feedbackId = feedbackId;
    subscriptionRef.current = subscription;

    return () => {
      if (subscriptionRef.current) {
        subscriptionRef.current.unsubscribe();
        subscriptionRef.current = null;
      }
    };
  }, [feedbackId]); // Remove handleMessage from dependencies
};
