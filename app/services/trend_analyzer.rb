class TrendAnalyzer
  def self.analyze_trends(days = 30)
    {
      sentiment_trend: Feedback.sentiment_trend(days),
      keyword_trends: analyze_keyword_trends(days),
      source_trends: analyze_source_trends(days)
    }
  end

  private

  def self.analyze_keyword_trends(days)
    Feedback.where('created_at > ?', days.days.ago)
           .pluck(:keywords)
           .flatten
           .tally
           .sort_by { |_, count| -count }
           .first(10)
           .to_h
  end

  def self.analyze_source_trends(days)
    Feedback.where('created_at > ?', days.days.ago)
           .group(:source_page)
           .count
  end
end
