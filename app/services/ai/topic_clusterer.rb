class Ai::TopicClusterer
  def self.cluster_feedback(topics)
    # Implementation to cluster feedback into topics
  end

  def self.get_clusters(limit: 5)
    mock_clusters = [
      {
        name: "Performance Issues",
        count: 23,
        trend: "+15%",
        sample_feedback: [
          "The website is loading very slowly today",
          "Pages take forever to load",
          "System performance has degraded"
        ]
      },
      {
        name: "UI/UX Feedback",
        count: 18,
        trend: "-5%",
        sample_feedback: [
          "The new design is confusing",
          "Can't find the search button easily",
          "Menu navigation is not intuitive"
        ]
      },
      {
        name: "Feature Requests",
        count: 15,
        trend: "+20%",
        sample_feedback: [
          "Would love to see dark mode",
          "Need export to PDF option",
          "Please add keyboard shortcuts"
        ]
      },
      {
        name: "Bug Reports",
        count: 12,
        trend: "-10%",
        sample_feedback: [
          "Getting error on checkout",
          "Can't submit the form",
          "Login page crashes sometimes"
        ]
      },
      {
        name: "Positive Feedback",
        count: 10,
        trend: "+5%",
        sample_feedback: [
          "Great new update!",
          "Love the new features",
          "Much better than before"
        ]
      }
    ]

    # Return only the requested number of clusters
    mock_clusters.first(limit)
  end
end
