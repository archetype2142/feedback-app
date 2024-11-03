import React from 'react';

export const NewChatButton = ({ handleNewChat }) => (
  <button
    onClick={handleNewChat}
    className="px-4 py-2 bg-emerald-500 text-white rounded-md hover:bg-emerald-600 transition-colors"
  >
    New Chat
  </button>
);
