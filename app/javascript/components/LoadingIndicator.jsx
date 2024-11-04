import React from 'react';

const LoadingIndicator = () => (
  <div className="flex justify-start">
    <div className="bg-gray-200 dark:bg-gray-700 rounded-lg p-4">
      <div className="flex space-x-2">
        {[0, 1, 2].map((i) => (
          <div 
            key={i}
            className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"
            style={{ animationDelay: `${i * 100}ms` }}
          />
        ))}
      </div>
    </div>
  </div>
);

export default LoadingIndicator;
