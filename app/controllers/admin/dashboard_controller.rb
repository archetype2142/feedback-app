class Admin::DashboardController < Admin::BaseController
  def index
    @trends = TrendAnalyzer.analyze_trends
    @action_items = ActionItem.includes(:feedback)
                            .where(status: ['pending', 'in_progress'])
                            .order(priority: :desc)
    @feedback_count = Feedback.count
    @unresolved_count = Feedback.unresolved.count
    
    # Ensure data exists for each sentiment
    @sentiment_distribution = {
      'positive' => Feedback.where(sentiment: 'positive').count,
      'neutral' => Feedback.where(sentiment: 'neutral').count,
      'negative' => Feedback.where(sentiment: 'negative').count
    }

    # Format hourly data
    @hourly_distribution = format_hourly_data(Feedback.hourly_distribution)
    
    # Format source data
    @source_distribution = Feedback.by_source.transform_keys { |k| k.presence || 'Direct' }
    
    # Format device data
    @device_distribution = Feedback.by_device.transform_keys { |k| k.presence || 'Unknown' }
    
    @recent_negative_feedbacks = Feedback.where(sentiment: 'negative').recent.limit(5)
    @suggested_actions = Feedback.group(:suggested_action).count


    # New variables for Sentiment Analysis tile
    @weekly_sentiment_change = calculate_weekly_sentiment_change
    @emotion_preview = Ai::TopicClusterer.get_clusters(limit: 5)

    @sentiment_weekly_avg = calculate_sentiment_weekly_average

    # New variables for Topic Clustering tile
    @top_clusters = get_top_clusters(limit: 5)
    @trending_topics = identify_trending_topics
    @cluster_distribution = calculate_cluster_distribution

    # New variables for Summaries tile
    @latest_summary_preview = generate_summary_preview
    

    @summary_stats = {
      total_analyzed: Feedback.last_week.count,
      key_topics: get_key_topics_last_week
    }



    # New variables for Impact Analysis tile
    # @latest_feature_impact = calculate_latest_feature_impact
    # @feature_releases = Feature.recent.limit(3)
    # @impact_metrics = calculate_recent_impact_metrics
    @impact_analysis = {
      recent_changes: calculate_recent_impact,
      latest_impact: calculate_latest_impact
    }
    # Add to existing index method in dashboard_controller.rb
    @sentiment_preview = {
      emotion_scores: Feedback.get_emotion_details(1.week.ago).limit(5),
      weekly_change: @weekly_sentiment_change,
      distribution: @sentiment_distribution
    }

    @topic_preview = {
      clusters: @top_clusters,
      trending: @trending_topics.first(3),
      total_analyzed: Feedback.last_week.count
    }

    @summary_preview = {
      latest: @latest_summary_preview,
      key_topics: @summary_stats[:key_topics],
      total_analyzed: @summary_stats[:total_analyzed]
    }

    @impact_preview = {
      recent_changes: @impact_analysis[:recent_changes],
      latest_impact: @impact_analysis[:latest_impact]
    }
  end

  def export
    @feedbacks = Feedback
    send_data FeedbackExporter.to_excel(@feedbacks).to_stream.read, filename: "feedbacks-#{Date.today}.xlsx"
  end

  private

  def calculate_weekly_sentiment_change
    current_week = Feedback.where('created_at >= ?', 1.week.ago)
                         .average(:sentiment_score).to_f
    previous_week = Feedback.where(created_at: 2.weeks.ago..1.week.ago)
                          .average(:sentiment_score).to_f
    
    return 0 if previous_week.zero?
    
    ((current_week - previous_week) / previous_week * 100).round(1)
  end

  def format_hourly_data(data)
    (0..23).map do |hour|
      formatted_hour = sprintf("%02d:00", hour)
      [formatted_hour, data[hour] || 0]
    end.to_h
  end

  def calculate_weekly_sentiment_change
    current_week = Feedback.where('created_at >= ?', 1.week.ago).average(:sentiment_score).to_f
    previous_week = Feedback.where(created_at: 2.weeks.ago..1.week.ago).average(:sentiment_score).to_f
    
    return 0 if previous_week.zero?
    
    ((current_week - previous_week) / previous_week * 100).round(1)
  end

  def calculate_sentiment_weekly_average
    Feedback.where('created_at >= ?', 1.week.ago)
           .group("DATE_TRUNC('day', created_at)")
           .average(:sentiment_score)
  end

  def get_top_clusters(limit: 5)
    Ai::TopicClusterer.get_clusters(limit: limit)
  end

  def identify_trending_topics
    # Get topics from current week with their counts
    current_week_topics = Feedback.where('created_at >= ?', 1.week.ago)
                                 .group(:content)
                                 .count

    # Get topics from previous week with their counts
    previous_week_topics = Feedback.where(created_at: 2.weeks.ago..1.week.ago)
                                  .group(:content)
                                  .count

    # Compare and identify trending topics
    trending = current_week_topics.map do |topic, current_count|
      previous_count = previous_week_topics[topic] || 0
      growth = if previous_count.zero?
                current_count > 0 ? 100 : 0
              else
                ((current_count - previous_count) / previous_count.to_f * 100).round(1)
              end
      
      [topic, {
        current_count: current_count,
        previous_count: previous_count,
        growth: growth
      }]
    end

    # Sort by growth rate and take top 3
    trending.sort_by { |_, stats| -stats[:growth] }.first(3)
  end

  def calculate_cluster_distribution
    # Instead of primary_topic, we'll use content analysis
    # You might want to use keywords or content categorization
    Feedback.group('sentiment').count  # Or another relevant grouping
  end

  def generate_summary_preview
    latest_feedback = Feedback.order(created_at: :desc).first
    return "No feedback available" unless latest_feedback
    
    latest_feedback.content.truncate(100)
  end

  def get_key_topics_last_week
    # Instead of primary_topic, we can use content analysis
    # Here's a simple example using keywords or content patterns
    Feedback.where('created_at >= ?', 1.week.ago)
           .select('content')
           .map { |f| f.analyze_topic }  # You'll need to implement analyze_topic
           .group_by { |topic| topic }
           .transform_values(&:count)
           .sort_by { |_, count| -count }
           .first(3)
           .map(&:first)
  end

  def calculate_latest_feature_impact
    latest_feature = Feature.last
    return "No features analyzed" unless latest_feature

    before_sentiment = Feedback.where('created_at < ?', latest_feature.release_date)
                             .where('created_at >= ?', latest_feature.release_date - 1.week)
                             .average(:sentiment_score).to_f
    
    after_sentiment = Feedback.where('created_at >= ?', latest_feature.release_date)
                            .where('created_at < ?', latest_feature.release_date + 1.week)
                            .average(:sentiment_score).to_f
    
    change = ((after_sentiment - before_sentiment) / before_sentiment * 100).round(1)
    
    "#{latest_feature.name}: #{change >= 0 ? '+' : ''}#{change}%"
  end

  def calculate_recent_impact_metrics
    Feature.recent.limit(3).map do |feature|
      {
        name: feature.name,
        sentiment_change: calculate_feature_sentiment_change(feature),
        feedback_volume_change: calculate_feature_feedback_volume_change(feature)
      }
    end
  end

  def calculate_recent_impact
    # Calculate impact based on sentiment changes over time periods
    current_period = Feedback.where('created_at >= ?', 1.week.ago)
                           .average(:sentiment_score).to_f
    previous_period = Feedback.where(created_at: 2.weeks.ago..1.week.ago)
                            .average(:sentiment_score).to_f

    change = previous_period.zero? ? 0 : ((current_period - previous_period) / previous_period * 100).round(1)
    
    {
      period: "Last 7 days",
      sentiment_change: change,
      current_score: current_period.round(2),
      previous_score: previous_period.round(2)
    }
  end

  def calculate_latest_impact
    latest_date = Feedback.maximum(:created_at)&.to_date
    return "No feedback available" unless latest_date

    recent_sentiment = Feedback.where('DATE(created_at) = ?', latest_date)
                             .average(:sentiment_score).to_f
    previous_sentiment = Feedback.where('DATE(created_at) = ?', latest_date - 1.day)
                                .average(:sentiment_score).to_f

    change = previous_sentiment.zero? ? 0 : ((recent_sentiment - previous_sentiment) / previous_sentiment * 100).round(1)
    
    "Daily change: #{change >= 0 ? '+' : ''}#{change}%"
  end

  def calculate_feature_sentiment_change(feature)
    # Similar to calculate_latest_feature_impact but for a specific feature
    # Returns the sentiment change percentage
  end

  def calculate_feature_feedback_volume_change(feature)
    # Calculate the change in feedback volume before and after feature release
    # Returns the volume change percentage
  end
end
