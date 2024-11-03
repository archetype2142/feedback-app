// hooks/useCableSubscription.js
import { useRef, useEffect, useCallback } from 'react';
import { createConsumer } from '@rails/actioncable';

const consumer = createConsumer();

export const useCableSubscription = (feedbackId, setCurrentFeedback) => {
  const subscriptionRef = useRef(null);
  
  // Memoize the message handler to keep it stable across renders
  const handleReceivedMessage = useCallback((data) => {
    console.log('📩 Received data:', data);

    switch(data.type) {
      case 'initial_state':
      case 'update':
        setCurrentFeedback(data.feedback);
        break;
      case 'test':
        console.log('Received test message:', data.message);
        break;
      default:
        console.log('Unknown message type:', data.type);
    }
  }, []);

   useEffect(() => {
    if (subscriptionRef.current) {
      subscriptionRef.current.subscription.unsubscribe();
      subscriptionRef.current = null;
    }

    if (feedbackId) {
      console.log('Setting up Action Cable subscription...', feedbackId);
      
      const subscription = consumer.subscriptions.create(
        {
          channel: 'FeedbackChannel',
          feedback_id: feedbackId
        },
        {
          connected() {
            console.log('🟢 Connected to FeedbackChannel');
          },
          disconnected() {
            console.log('🔴 Disconnected from FeedbackChannel');
          },
          rejected() {
            console.log('❌ Subscription rejected');
          },
          received: handleReceivedMessage
        }
      );

      subscriptionRef.current = {
        feedbackId,
        subscription
      };
    }

    return () => {
      if (subscriptionRef.current) {
        console.log('Cleaning up subscription...');
        subscriptionRef.current.subscription.unsubscribe();
        subscriptionRef.current = null;
      }
    };
  }, [feedbackId, handleReceivedMessage]);

  return subscriptionRef.current?.subscription;
};
