import { useEffect, useCallback } from 'react';
import { createConsumer } from '@rails/actioncable';

const consumer = createConsumer();

export const useCableSubscription = (feedbackId, setCurrentFeedback) => {
  const handleMessage = useCallback((data) => {
    if (data.type === 'initial_state' || data.type === 'update') {
      setCurrentFeedback(data.feedback);
    }
  }, [setCurrentFeedback]);

  useEffect(() => {
    if (!feedbackId) return;

    const subscription = consumer.subscriptions.create(
      { channel: 'FeedbackChannel', feedback_id: feedbackId },
      { received: handleMessage }
    );

    return () => subscription.unsubscribe();
  }, [feedbackId, handleMessage]);
};
