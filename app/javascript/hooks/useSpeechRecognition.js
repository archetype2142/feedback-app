import { useState, useEffect } from 'react';
import { toast } from 'react-toastify';

export const useSpeechRecognition = (onTranscriptChange) => {
  const [isListening, setIsListening] = useState(false);
  const [recognition, setRecognition] = useState(null);

  useEffect(() => {
    if ('webkitSpeechRecognition' in window) {
      const newRecognition = new window.webkitSpeechRecognition();
      newRecognition.continuous = true;
      newRecognition.interimResults = true;

      newRecognition.onstart = () => {
        setIsListening(true);
        toast.info('Listening...');
      };

      newRecognition.onresult = (event) => {
        let interimTranscript = '';
        let finalTranscript = '';

        for (let i = event.resultIndex; i < event.results.length; i++) {
          const transcript = event.results[i][0].transcript;
          if (event.results[i].isFinal) {
            finalTranscript += transcript;
          } else {
            interimTranscript += transcript;
          }
        }

        onTranscriptChange(prevMessage => {
          const withoutInterim = prevMessage.replace(/\(typing\.\.\.\).*$/, '').trim();
          return `${withoutInterim} ${finalTranscript} ${interimTranscript ? `(typing...) ${interimTranscript}` : ''}`.trim();
        });
      };

      newRecognition.onerror = (event) => {
        if (event.error === 'no-speech') {
          toast.warn('No speech detected. Please try again.');
        } else {
          toast.error('Speech recognition error');
        }
        setIsListening(false);
      };

      newRecognition.onend = () => {
        setIsListening(false);
      };

      setRecognition(newRecognition);
    } else {
      toast.error('Speech recognition is not supported in this browser.');
    }

    return () => {
      if (recognition) {
        recognition.stop();
      }
    };
  }, []);

  return { isListening, recognition, setIsListening };
};
