class Feedback < ApplicationRecord
  has_many :replies, -> { ordered }, dependent: :destroy

  # after_create :create_action_item_if_negative

  validates :content, presence: true
  
  enum status: {
    pending: 'pending',
    in_progress: 'in_progress',
    resolved: 'resolved',
    archived: 'archived'
  }

  before_save :analyze_sentiment
  before_save :suggest_action

  scope :recent, -> { order(created_at: :desc) }
  scope :unresolved, -> { where.not(status: :resolved) }
  scope :by_sentiment, -> { group(:sentiment).count }
  scope :by_status, -> { group(:status).count }
  scope :by_source, -> { group(:source_page).count }
  scope :by_device, -> { group(:device_type).count }
  scope :last_week, -> { where('created_at >= ?', 1.week.ago) }

  def self.hourly_distribution
    group_by_hour_of_day(:created_at, format: "%l %P").count
  end

  scope :trending_topics, -> {
    where('created_at > ?', 7.days.ago)
      .group(:keywords)
      .count
      .sort_by { |_, count| -count }
      .first(10)
  }

  def self.sentiment_trend(days = 30)
    where('created_at > ?', days.days.ago)
      .group('DATE(created_at)', :sentiment)
      .count
      .transform_keys { |date, sentiment| [date, sentiment] }
  end

  def analyze_sentiment
    self.sentiment = if self.sentiment_score > 0
                      'positive'
                    elsif self.sentiment_score < 0
                      'negative'
                    else
                      'neutral'
                    end
  end

  def suggest_action
    self.suggested_action = case sentiment
    when 'negative'
      if content.include?('slow') || content.include?('performance')
        'Investigate performance issues'
      elsif content.include?('error') || content.include?('bug')
        'Check error logs and debug'
      else
        'Review feedback for urgent issues'
      end
    when 'positive'
      'Consider for testimonials'
    else
      'Monitor for patterns'
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["browser", "content", "created_at", "device_type", "id", "id_value", "platform", "sentiment", "sentiment_score", "source_page", "status", "suggested_action", "updated_at"]
  end

  def create_action_item_if_negative
    return unless sentiment == 'negative'

    ActionItem.create!(
      feedback: self,
      title: "Address Negative Feedback",
      description: "Review and address: #{content}",
      status: 'pending',
      priority: 'high'
    )
  end

  scope :with_emotion_scores, -> { 
    select("*").select(
      "CASE 
        WHEN sentiment_score >= 0.7 THEN 'very_positive'
        WHEN sentiment_score >= 0.3 THEN 'positive'
        WHEN sentiment_score > -0.3 THEN 'neutral'
        WHEN sentiment_score > -0.7 THEN 'negative'
        ELSE 'very_negative'
      END as emotion"
    )
  }

  def self.get_emotion_details(start_date = 1.month.ago, end_date = Time.current)
    with_emotion_scores
      .where(created_at: start_date..end_date)
      .select('content, sentiment_score, emotion, created_at')
      .order(created_at: :desc)
  end

  # Modified method to get emotion trend
  def self.emotion_trend(days = 30)
    select(
      "DATE(created_at) as date",
      "CASE 
        WHEN sentiment_score >= 0.7 THEN 'very_positive'
        WHEN sentiment_score >= 0.3 THEN 'positive'
        WHEN sentiment_score > -0.3 THEN 'neutral'
        WHEN sentiment_score > -0.7 THEN 'negative'
        ELSE 'very_negative'
      END as emotion"
    )
    .where('created_at > ?', days.days.ago)
    .group('date', 'emotion')
    .count
  end

  # Add method to calculate emotion
  def emotion_score
    case
    when sentiment_score >= 0.7
      { score: sentiment_score, label: 'very_positive' }
    when sentiment_score >= 0.3
      { score: sentiment_score, label: 'positive' }
    when sentiment_score > -0.3
      { score: sentiment_score, label: 'neutral' }
    when sentiment_score > -0.7
      { score: sentiment_score, label: 'negative' }
    else
      { score: sentiment_score, label: 'very_negative' }
    end
  end

  def calculate_emotion
    case 
    when sentiment_score >= 0.7
      'very_positive'
    when sentiment_score >= 0.3
      'positive'
    when sentiment_score > -0.3
      'neutral'
    when sentiment_score > -0.7
      'negative'
    else
      'very_negative'
    end
  end

  # Modify the analyze_sentiment method to be more granular
  def analyze_sentiment
    self.sentiment = case
    when sentiment_score >= 0.3
      'positive'
    when sentiment_score <= -0.3
      'negative'
    else
      'neutral'
    end
  end


  # Add method to get emotion trend
  def self.emotion_trend(days = 30)
    with_emotion_scores
      .where('created_at > ?', days.days.ago)
      .group('DATE(created_at)', 'emotion')
      .count
  end

   def analyze_topic
    # Convert content to lowercase for case-insensitive matching
    text = content.to_s.downcase

    # Define topic patterns with their associated keywords
    topic_patterns = {
      'Bug/Error' => [
        'bug', 'error', 'crash', 'issue', 'problem', 'broken', 'not working',
        'failed', 'failure', 'exception'
      ],
      
      'Performance' => [
        'slow', 'fast', 'speed', 'performance', 'loading', 'lag', 'timeout',
        'response time', 'efficient', 'inefficient'
      ],
      
      'UI/UX' => [
        'interface', 'design', 'layout', 'ui', 'ux', 'look', 'feel',
        'button', 'menu', 'navigation', 'confusing', 'unclear', 'intuitive'
      ],
      
      'Feature Request' => [
        'feature', 'add', 'would like', 'should have', 'missing', 'need',
        'suggestion', 'recommend', 'could use', 'wishlist'
      ],
      
      'Usability' => [
        'difficult', 'easy', 'hard to', 'can\'t find', 'confusing',
        'unclear', 'complex', 'simple', 'usability'
      ],
      
      'Documentation' => [
        'docs', 'documentation', 'guide', 'help', 'tutorial',
        'instructions', 'example', 'explain'
      ],
      
      'Account/Login' => [
        'login', 'account', 'sign in', 'signup', 'password',
        'authentication', 'logout', 'register'
      ],
      
      'Data/Content' => [
        'data', 'content', 'information', 'text', 'image',
        'video', 'file', 'upload', 'download'
      ]
    }

    # Find matching topics based on keyword presence
    matches = topic_patterns.map do |topic, keywords|
      match_count = keywords.count { |keyword| text.include?(keyword) }
      [topic, match_count]
    end

    # Get the topic with the most keyword matches
    best_match = matches.max_by { |_, count| count }
    
    # Return 'General Feedback' if no strong matches found
    return 'General Feedback' if best_match[1].zero?
    
    best_match[0]
  end
end
