import React, { useState, useEffect, useRef } from 'react';

const LoadingIndicator = () => (
  <div className="flex justify-start">
    <div className="bg-gray-200 dark:bg-gray-700 rounded-lg p-4 max-w-md">
      <div className="flex space-x-1">
        <div 
          className="w-2 h-2 bg-gray-400 rounded-full"
          style={{ 
            animation: 'bounce 0.7s infinite',
            animationDelay: '0ms',
            transform: 'translateY(0)',
            animationTimingFunction: 'cubic-bezier(0.28, 0.84, 0.42, 1)'
          }}
        />
        <div 
          className="w-2 h-2 bg-gray-400 rounded-full"
          style={{ 
            animation: 'bounce 0.7s infinite',
            animationDelay: '100ms',
            transform: 'translateY(0)',
            animationTimingFunction: 'cubic-bezier(0.28, 0.84, 0.42, 1)'
          }}
        />
        <div 
          className="w-2 h-2 bg-gray-400 rounded-full"
          style={{ 
            animation: 'bounce 0.7s infinite',
            animationDelay: '200ms',
            transform: 'translateY(0)',
            animationTimingFunction: 'cubic-bezier(0.28, 0.84, 0.42, 1)'
          }}
        />
      </div>
    </div>
  </div>
);

export default LoadingIndicator;
