import React from 'react';

const ChatInput = ({ 
  message, 
  setMessage, 
  isSubmitting, 
  isListening, 
  handleSubmit, 
  startListening, 
  stopListening 
}) => {
  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey && window.innerWidth >= 768) {
      e.preventDefault();
      if (message.trim()) handleSubmit(e);
    }
  };

  const handleChange = (e) => {
    setMessage(e.target.value);
  };

  return (
    <div className="border-t border-gray-200 dark:border-white bg-white dark:bg-black p-4">
      <form onSubmit={handleSubmit} className="max-w-3xl mx-auto flex gap-3 items-center">
        <div className="relative flex-1">
          <textarea
            value={message}
            onChange={handleChange}
            onKeyDown={handleKeyDown}
            placeholder="Type your message"
            className="h-[57px] w-full p-4 pr-14 text-gray-900 dark:text-white bg-white dark:bg-black rounded-full border border-white dark:border-white focus:ring-2 focus:ring-emerald-500 focus:border-transparent resize-none overflow-y-auto scrollbar-hide"
            disabled={isSubmitting}
          />
          <button
            type="button"
            onClick={isListening ? stopListening : startListening}
            className={`absolute right-2 top-2 p-2 rounded-full ${
              isListening ? 'bg-red-500 text-white' : 'bg-gray-100 dark:bg-white'
            }`}
          >
            <svg className="w-6 h-6" viewBox="0 0 24 24">
              <path fill="none" strokeWidth="1.5" stroke="currentColor" 
                d="M12 18.75a6 6 0 006-6v-1.5m-6 7.5a6 6 0 01-6-6v-1.5m6 7.5v3.75m-3.75 0h7.5M12 15.75a3 3 0 01-3-3V4.5a3 3 0 116 0v8.25a3 3 0 01-3 3z" 
              />
            </svg>
          </button>
        </div>

        <button
          type="submit"
          disabled={isSubmitting || !message.trim()}
          className={`rounded-xl p-3 ${
            message.trim() ? 'bg-emerald-500 hover:bg-emerald-600' : 'bg-gray-100'
          } text-white`}
        >
          <svg className="w-6 h-6" viewBox="0 0 24 24">
            <path fill="none" strokeWidth="1.5" stroke="currentColor"
              d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"
            />
          </svg>
        </button>
      </form>
    </div>
  );
};

export default ChatInput;
