class Api::FeedbacksController < Api::BaseController
  def index
    @feedbacks = Feedback.includes(:replies).order(created_at: :desc)
    render json: @feedbacks.as_json(include: :replies)
  end

  def show
    @feedback = Feedback.includes(:replies).find(params[:id])
    render json: @feedback.as_json(include: :replies)
  end

  def create
    feedback_text = params[:feedback][:content]
    analysis = ::InitialFeedbackJob.new.perform(feedback_text)

    if analysis
      @feedback = Feedback.new(
        content: feedback_text,
        sentiment_score: analysis['sentiment_score'],
        source_page: request.referer,
        browser: RequestStore.store[:browser].name,
        platform: RequestStore.store[:browser].platform.name,
        device_type: RequestStore.store[:browser].device.name
      )

      if @feedback.save
        @feedback.replies.create!(
          content: analysis['output'],
          feedback_id: @feedback.id,
          sender_type: 'system'
        )

        FeedbackChannel.broadcast_to(@feedback, { 
          feedback: @feedback.as_json(include: :replies)
        })
        # Your existing broadcast logic here
        render json: @feedback.as_json(include: :replies)
      else
        render json: { errors: @feedback.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Failed to analyze feedback' }, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content)
  end
end
