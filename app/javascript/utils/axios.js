// app/javascript/utils/axios.js
import axios from 'axios';
import { getCSRFToken } from './csrf';

const instance = axios.create({
  headers: {
    'X-CSRF-Token': getCSRFToken(),
    'Content-Type': 'application/json',
  },
  withCredentials: true
});

export default instance;

// Then in your component:
import axios from '../utils/axios';

// ... in handleSubmit:
try {
  const response = await axios.post('/api/feedbacks', {
    feedback: { content: feedback }
  });
  
  if (response.status === 201) {
    setFeedback('');
    toast.success('Feedback submitted successfully!');
  }
} catch (error) {
  toast.error(error.response?.data?.error || 'Error submitting feedback');
} finally {
  setIsSubmitting(false);
}
