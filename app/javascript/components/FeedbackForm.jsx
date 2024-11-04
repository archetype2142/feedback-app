import React, { useState, useEffect, useCallback } from 'react';
import { toast } from 'react-toastify';
import LoadingIndicator from './LoadingIndicator';
import ChatMessage from './ChatMessage';
import { languages } from '../constants/languages';
import { useSpeechRecognition } from '../hooks/useSpeechRecognition';
import { fetchFeedback, createFeedback, createReply } from '../services/feedbackService';
import  useFeedbackState from '../hooks/useFeedbackState';
import { useCableSubscription } from '../hooks/useCableSubscription';
import ChatHeader from './ChatHeader';
import ChatBody from './ChatBody';
import ChatInput from './ChatInput';

const WelcomeLogo = () => (
  <div className="w-full flex justify-center items-center h-full">
    <img
      className="w-52 h-52"
      src='/hearfront.jpeg'
      alt="logo"
    />
  </div>
);

const FeedbackForm = () => {
  const [message, setMessage] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [selectedLanguage, setSelectedLanguage] = useState('en-US');
  const [isResponseLoading, setIsResponseLoading] = useState(false);
  const [shouldSubscribe, setShouldSubscribe] = useState(false);

  const { 
    currentFeedback, 
    setCurrentFeedback, 
    handleFetchFeedback 
  } = useFeedbackState();

  const handleFeedbackUpdate = useCallback((feedback) => {
    setCurrentFeedback(feedback);
  }, [setCurrentFeedback]);

  const subscription = useCableSubscription(currentFeedback?.id, handleFeedbackUpdate);
  const { isListening, recognition, setIsListening } = useSpeechRecognition(setMessage);

  const addMessageToChat = (content, isUser = true) => {
    if (!currentFeedback) {
      // For initial feedback, set it up with the user's message
      setCurrentFeedback({
        id: `temp-${Date.now()}`,
        content: '', // Leave content empty as it's not a system message
        created_at: new Date().toISOString(),
        replies: [{
          id: `temp-${Date.now()}`,
          content: content,
          created_at: new Date().toISOString(),
          sender_type: isUser ? 'user' : 'system'
        }]
      });
    } else {
      setCurrentFeedback(prev => ({
        ...prev,
        replies: [
          ...prev.replies,
        ]
      }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!message.trim()) {
      toast.error('Please enter a message');
      return;
    }

    const messageContent = message;
    setMessage('');
    setIsSubmitting(true);
    setIsResponseLoading(true);
    
    addMessageToChat(messageContent);

    try {
      if (!currentFeedback) {
        const data = await createFeedback(messageContent);
        setCurrentFeedback(data);
        localStorage.setItem('currentFeedbackId', data.id);
        setShouldSubscribe(true); // Enable subscription after initial feedback
      } else {
        const data = await createReply(currentFeedback.id, messageContent);
        setCurrentFeedback(prev => ({
          ...prev,
          replies: [...prev.replies, data]
        }));
      }

      toast.success('Message sent!');
    } catch (error) {
      toast.error(error.message || 'Error sending message');
    } finally {
      setIsSubmitting(false);
      setIsResponseLoading(false);
    }
  };

  useEffect(() => {
    if (currentFeedback?.id && !currentFeedback.id.toString().includes('temp')) {
      setShouldSubscribe(true);
    }
  }, [currentFeedback?.id]);

  const handleNewChat = () => {
    localStorage.removeItem('currentFeedbackId');
    setCurrentFeedback(null);
    setMessage('');
    setShouldSubscribe(false); // Disable subscription for new chat
  };

  const startListening = () => {
    if (recognition) {
      recognition.lang = selectedLanguage;
      recognition.start();
    } else {
      toast.error('Speech recognition is not supported in this browser.');
    }
  };

  const stopListening = () => {
    if (recognition) {
      recognition.stop();
      setMessage(prev => prev.replace(/\(typing\.\.\.\).*$/, '').trim());
    }
  };

  return (
     <div className="flex flex-col h-[100dvh] max-h-[100dvh] overflow-hidden bg-gray-50 dark:bg-black">
      <ChatHeader 
        selectedLanguage={selectedLanguage}
        setSelectedLanguage={setSelectedLanguage}
        isListening={isListening}
        handleNewChat={handleNewChat}
      />
      
      {!currentFeedback && <WelcomeLogo />}
      
      { currentFeedback &&
        <ChatBody 
          currentFeedback={currentFeedback}
          isResponseLoading={isResponseLoading}
        />
      }
      <div className="flex-none">
        <ChatInput 
          message={message}
          setMessage={setMessage}
          isSubmitting={isSubmitting}
          isListening={isListening}
          handleSubmit={handleSubmit}
          startListening={startListening}
          stopListening={stopListening}
        />
      </div>
    </div>
  );
};

export default FeedbackForm;
