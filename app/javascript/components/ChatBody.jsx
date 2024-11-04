import React, { useEffect, useRef } from 'react';
import ChatMessage from './ChatMessage';
import LoadingIndicator from './LoadingIndicator';

const ChatBody = ({ currentFeedback, isResponseLoading }) => {
  const messagesEndRef = useRef(null);
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [currentFeedback?.replies, isResponseLoading]);

  return (<div className="flex-1 overflow-y-auto px-4 py-6">
    <div className="max-w-3xl mx-auto space-y-4">
      {currentFeedback && (
        <>
          {/* Only show the initial feedback message if it has content */}
          {currentFeedback.content && (
            <ChatMessage 
              message={currentFeedback} 
              isUser={true} // System message
            />
          )}

          {currentFeedback.replies.map((reply) => (
            <ChatMessage 
              key={reply.id}
              message={reply}
              isUser={reply.sender_type === 'user'}
            />
          ))}

          {isResponseLoading && <LoadingIndicator />}
          <div ref={messagesEndRef} />
        </>
      )}
    </div>
  </div>
  );
};

export default ChatBody;
