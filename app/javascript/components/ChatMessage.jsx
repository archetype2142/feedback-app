import React, { useState, useEffect, useRef } from 'react';

const ChatMessage = ({ message, isUser }) => {
  
  console.log(message, isUser);

  return (
    <div className={`flex ${isUser ? 'justify-end' : 'justify-start'}`}>
      <div
        className={`rounded-lg p-4 max-w-md ${
          isUser
            ? 'bg-emerald-500 text-white'
            : 'bg-gray-200 dark:bg-gray-700 text-gray-900 dark:text-white'
        }`}
      >
        <p>{message.content}</p>
        <span className="text-xs opacity-75">
          {new Date(message.created_at).toLocaleString()}
        </span>
      </div>
    </div>
  );
};

export default ChatMessage;


// .filter(reply => reply?.feedback_id)
