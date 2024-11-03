# app/controllers/admin/summaries_controller.rb
class Admin::SummariesController < Admin::BaseController
  def index
    @timeframe = params[:timeframe] || 'weekly'
    @summaries = generate_summaries
  end

  private

  def generate_summaries
    case @timeframe
    when 'weekly'
      generate_weekly_summaries
    when 'monthly'
      generate_monthly_summaries
    end
  end

  def generate_weekly_summaries
    4.times.map do |i|
      start_date = i.weeks.ago.beginning_of_week
      end_date = start_date.end_of_week
      
      OpenStruct.new(
        start_date: start_date,
        end_date: end_date,
        timeframe: 'weekly',
        content: generate_summary_content(start_date, end_date)
      )
    end
  end

  def generate_monthly_summaries
    3.times.map do |i|
      start_date = i.months.ago.beginning_of_month
      end_date = start_date.end_of_month
      
      OpenStruct.new(
        start_date: start_date,
        end_date: end_date,
        timeframe: 'monthly',
        content: generate_summary_content(start_date, end_date)
      )
    end
  end

  def generate_summary_content(start_date, end_date)
    feedbacks = Feedback.where(created_at: start_date..end_date)
    total = feedbacks.count

    if total.zero?
      return "No feedback received during this period."
    end

    positive = feedbacks.where(sentiment: 'positive').count
    negative = feedbacks.where(sentiment: 'negative').count
    
    positive_percentage = ((positive.to_f/total) * 100).round(1)
    negative_percentage = ((negative.to_f/total) * 100).round(1)
    
    topics = feedbacks.map(&:analyze_topic).uniq.first(3)
    topics_text = topics.any? ? topics.join(', ') : "no specific topics"

    "Analyzed #{total} pieces of feedback. " \
    "#{positive} were positive (#{positive_percentage}%) and " \
    "#{negative} were negative (#{negative_percentage}%). " \
    "Key topics included #{topics_text}."
  rescue => e

    "Error generating summary: #{e.message}"
  end
end
