// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "chartkick/chart.js"

// app/javascript/sentiment_analysis.js
function showEmotionDetails(feedbackId) {
  fetch(`/admin/sentiment_analysis/${feedbackId}`)
    .then(response => response.json())
    .then(data => {
      // Show modal with emotion details
      alert(JSON.stringify(data, null, 2));
    });
}

// app/javascript/topic_clusters.js
function showTopicFeedbacks(topic) {
  fetch(`/admin/topic_clusters/topic_feedbacks?topic=${encodeURIComponent(topic)}`)
    .then(response => response.json())
    .then(data => {
      // Show modal with topic feedbacks
      alert(JSON.stringify(data, null, 2));
    });
}
