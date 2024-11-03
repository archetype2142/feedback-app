import React from 'react';
import { LanguageSelector } from './LanguageSelector';
import { NewChatButton } from './NewChatButton';


const ChatHeader = ({ selectedLanguage, setSelectedLanguage, isListening, handleNewChat }) => (
  <div className="flex justify-between">
    <div className="w-full max-w-3xl mx-auto px-2 py-4">
      <div className="flex justify-between items-center">
        <LanguageSelector 
          selectedLanguage={selectedLanguage} 
          setSelectedLanguage={setSelectedLanguage}
          isListening={isListening}
        />
        <NewChatButton handleNewChat={handleNewChat} />
      </div>
    </div>
  </div>
);

export default ChatHeader;
