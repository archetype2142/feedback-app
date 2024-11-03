# app/controllers/admin/sentiment_analysis_controller.rb
class Admin::SentimentAnalysisController < Admin::BaseController
  def index
    @emotion_scores = Feedback.with_emotion_scores
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)

    @sentiment_trend = Feedback.group_by_week(:created_at)
                             .average(:sentiment_score)
                             .map { |date, score| [date, score.round(2)] }
                             .to_h

    @weekly_insight = generate_weekly_insight
  end

  def show
    @feedback = Feedback.find(params[:id])
    render json: {
      content: @feedback.content,
      emotion_score: @feedback.emotion_score,
      created_at: @feedback.created_at,
      details: generate_emotion_details(@feedback)
    }
  end

  private

  def generate_weekly_insight
    current_week_avg = Feedback.where('created_at >= ?', 1.week.ago).average(:sentiment_score).to_f
    prev_week_avg = Feedback.where(created_at: 2.weeks.ago..1.week.ago).average(:sentiment_score).to_f
    
    change = ((current_week_avg - prev_week_avg) / prev_week_avg * 100).round(1)
    direction = change.positive? ? "improved" : "declined"
    
    "Customer sentiment has #{direction} by #{change.abs}% over the last week. " \
    "The average sentiment score is #{current_week_avg.round(2)}."
  end

  def generate_emotion_details(feedback)
    {
      keywords: extract_keywords(feedback.content),
      topic: feedback.analyze_topic(feedback.content),
      detailed_score: feedback.emotion_score
    }
  end

  def extract_keywords(content)
    content.downcase.split(/\W+/).uniq
           .reject { |word| %w[the and or in on at].include?(word) }
           .first(5)
  end
end
