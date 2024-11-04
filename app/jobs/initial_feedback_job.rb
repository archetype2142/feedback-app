class InitialFeedbackJob < ApplicationJob
  queue_as :default

  def perform(feedback, callback_url = nil)
    openai_service = OpenaiService.new
    # initial_response = openai_service.get_completion(PROMPT_1, feedback)
    # feedback_data = JSON.parse(initial_response)
    feedback_data = {"feedback"=>["test"], "sentiment_score"=>0, "good_points"=>[]}

    sentiment_score = feedback_data['sentiment_score']

    final_output = case
    when sentiment_score < -1
      ::RESPONSE_NEG
    when sentiment_score > -1 && sentiment_score < 1
      ::RESPONSE_NEU
    else
      ::RESPONSE_POS
    end

    feedback_data['output'] = final_output

    feedback_data
  end
end
