class Api::RepliesController < Api::BaseController
  def create
    feedback = Feedback.find(params[:feedback_id])
    reply = feedback.replies.build(reply_params)

    if reply.save
      FeedbackChannel.broadcast_to(feedback, {
        feedback: feedback.as_json(include: :replies)
      })
      
      ::ProcessSystemResponseJob.perform_async(params[:feedback_id])
      
      render json: feedback.as_json(include: :replies), status: :created
    else
      render json: { errors: reply.errors }, status: :unprocessable_entity
    end
  end

  private

  def reply_params
    params.require(:reply).permit(:content).merge(sender_type: 'user')
  end
end
