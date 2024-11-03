import React, { useRef, useEffect, useState } from 'react';

const ChatInput = ({ 
  message, 
  setMessage, 
  isSubmitting, 
  isListening, 
  handleSubmit, 
  startListening, 
  stopListening 
}) => {
  const textareaRef = useRef(null);
  const [isDesktop, setIsDesktop] = useState(window.innerWidth >= 768);

  useEffect(() => {
    const handleResize = () => {
      setIsDesktop(window.innerWidth >= 768);
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const handleKeyDown = (e) => {
    if (isDesktop && e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      if (message.trim()) {
        handleSubmit(e);
      }
    }
  };

  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.scrollTop = textareaRef.current.scrollHeight;
    }
  }, [message]);

  const handleChange = (e) => {
    setMessage(e.target.value);
  };

  return (
    <div className="border-t border-gray-200 dark:border-white bg-white dark:bg-black px-4 py-4">
      <div className="max-w-3xl mx-auto">
        <form onSubmit={handleSubmit} className="flex gap-3 items-center justify-center">
          <div className="relative flex-1">
            <textarea
              ref={textareaRef}
              value={message}
              onChange={handleChange}
              onKeyDown={handleKeyDown}
              placeholder={isDesktop ? "Press Enter to send" : "Type your message"}
              rows={1}
              className="h-[57px] w-full p-4 pr-14 text-gray-900 dark:text-white bg-white dark:bg-black rounded-full border border-white dark:border-white focus:ring-2 focus:ring-emerald-500 focus:border-transparent resize-none overflow-y-auto scrollbar-hide"
              disabled={isSubmitting}
              style={{
                scrollbarWidth: 'none',  // Firefox
                msOverflowStyle: 'none',  // IE/Edge
                '::-webkit-scrollbar': {  // Chrome/Safari/Webkit
                  display: 'none'
                }
              }}
            />
            <button
              type="button"
              onClick={isListening ? stopListening : startListening}
              disabled={isSubmitting}
              className={`absolute right-2 top-2 p-2 rounded-full transition-colors ${
                isListening
                  ? 'bg-red-500 hover:bg-red-600 text-white'
                  : 'bg-gray-100 dark:bg-white hover:bg-gray-200 dark:hover:bg-gray-500 text-black dark:text-black'
              }`}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="w-6 h-6"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M12 18.75a6 6 0 006-6v-1.5m-6 7.5a6 6 0 01-6-6v-1.5m6 7.5v3.75m-3.75 0h7.5M12 15.75a3 3 0 01-3-3V4.5a3 3 0 116 0v8.25a3 3 0 01-3 3z"
                />
              </svg>
            </button>
          </div>
          <button
            type="submit"
            disabled={isSubmitting || !message.trim()}
            className={`rounded-xl transition-colors p-3 flex items-center justify-center ${
              message.trim()
                ? 'bg-emerald-500 hover:bg-emerald-600 text-white'
                : 'bg-gray-100 dark:bg-gray-600 text-gray-400 dark:text-gray-500 cursor-not-allowed'
            }`}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={1.5}
              stroke="currentColor"
              className="w-6 h-6"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"
              />
            </svg>
          </button>
        </form>
      </div>
    </div>
  );
};

export default ChatInput;
