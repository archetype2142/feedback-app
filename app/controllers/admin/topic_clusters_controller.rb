# app/controllers/admin/topic_clusters_controller.rb
class Admin::TopicClustersController < Admin::BaseController
  def index
    @topics = default_topics
    @selected_topics = params[:topics] || @topics
    @clusters = generate_clusters
    @topic_insight = generate_topic_insight
  end

  def topic_feedbacks
    @feedbacks = Feedback.where("content ILIKE ?", "%#{params[:topic]}%")
                        .order(created_at: :desc)
                        .limit(10)
    
    render json: @feedbacks
  end

  private

  def default_topics
    ['Bug/Error', 'Performance', 'UI/UX', 'Feature Request', 
     'Usability', 'Documentation', 'Account/Login', 'Data/Content']
  end

  def generate_clusters
    Feedback.last_week.group_by { |f| f.analyze_topic }
  end

  def generate_topic_insight
    top_topic = generate_clusters.max_by { |_, feedbacks| feedbacks.count }
    count = top_topic[1].count
    
    "The most discussed topic this week was '#{top_topic[0]}' " \
    "with #{count} pieces of feedback. This represents " \
    "#{((count.to_f / Feedback.last_week.count) * 100).round}% of total feedback."
  end
end
