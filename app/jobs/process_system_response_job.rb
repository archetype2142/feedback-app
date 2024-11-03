class ProcessSystemResponseJob
  include Sidekiq::Job
  queue_as :default
  sidekiq_options retry: false

  def perform(feedback_id)
    feedback = Feedback.find(feedback_id)
    last_reply_id = feedback.replies.where(sender_type: 'user').last.id

    response_content = generate_contextual_response(feedback, last_reply_id)
    
    ActiveRecord::Base.transaction do
      reply = feedback.replies.create!(
        content: response_content['outro'],
        sender_type: 'system'
      )

      feedback.reload

      feedback.update!(keywords: response_content['points'])

      broadcast_data = {
        type: 'update',
        feedback: feedback.as_json(include: :replies)
      }

      # Channel broadcast attempt
      FeedbackChannel.broadcast_to(
        feedback,
        broadcast_data
      )
    end
  rescue => e
    Rails.logger.error "!!! Error in ProcessSystemResponseJob !!!"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    raise e
  end

  private

  def generate_contextual_response(feedback, last_reply_id)
    openai_service = OpenaiService.new
    initial_response = openai_service.get_completion(PROMPT_2, feedback)

    feedback_response = JSON.parse(initial_response)
    feedback_data = Hash.new
    feedback_data['points'] = feedback_response
    feedback_data['outro'] = ::OUTRO
    feedback_data
  end
end
