# app/controllers/admin/impact_analysis_controller.rb
class Admin::ImpactAnalysisController < Admin::BaseController
  def index
    @features = mock_features
    @selected_feature = @features.find { |f| f.id == params[:feature_id].to_i } || @features.first
    @date_range = params[:date_range] || '30_days'
    @impact_analysis = generate_impact_analysis
  end

  private

  def mock_features
    [
      OpenStruct.new(id: 1, name: 'New Dashboard', release_date: 2.weeks.ago),
      OpenStruct.new(id: 2, name: 'Mobile App Update', release_date: 1.month.ago),
      OpenStruct.new(id: 3, name: 'Search Improvement', release_date: 2.months.ago)
    ]
  end

  def generate_impact_analysis
    release_date = @selected_feature.release_date
    before_date = case @date_range
                 when '7_days'
                   7.days
                 when '30_days'
                   30.days
                 else
                   90.days
                 end

    before_feedbacks = Feedback.where(created_at: (release_date - before_date)..release_date)
    after_feedbacks = Feedback.where(created_at: release_date..(release_date + before_date))

    OpenStruct.new(
      summary: generate_impact_summary(before_feedbacks, after_feedbacks),
      sentiment_chart_data: generate_sentiment_chart_data(before_feedbacks, after_feedbacks),
      before_feedbacks: before_feedbacks.limit(5),
      after_feedbacks: after_feedbacks.limit(5)
    )
  end

  def generate_impact_summary(before_feedbacks, after_feedbacks)
    before_avg = before_feedbacks.average(:sentiment_score).to_f
    after_avg = after_feedbacks.average(:sentiment_score).to_f
    change = ((after_avg - before_avg) / before_avg * 100).round(1)
    
    "After the release of #{@selected_feature.name}, sentiment " \
    "#{change >= 0 ? 'improved' : 'declined'} by #{change.abs}%. " \
    "Average sentiment score changed from #{before_avg.round(2)} to #{after_avg.round(2)}."
  end

  def generate_sentiment_chart_data(before_feedbacks, after_feedbacks)
    {
      'Before Release' => before_feedbacks.group_by_day(:created_at).average(:sentiment_score),
      'After Release' => after_feedbacks.group_by_day(:created_at).average(:sentiment_score)
    }
  end
end
