# app/channels/feedback_channel.rb
class FeedbackChannel < ApplicationCable::Channel
  def subscribed
    feedback = Feedback.find(params[:feedback_id])
    stream_from "feedback_#{feedback.id}"
    stream_for feedback
    
    # Send initial state
    transmit({
      type: 'initial_state',
      feedback: feedback.as_json(include: :replies)
    })
  end

  def unsubscribed
    Rails.logger.info "=== FeedbackChannel#unsubscribed ==="
    Rails.logger.info "Params: #{params.inspect}"
  end
end
