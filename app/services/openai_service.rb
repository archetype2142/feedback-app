class OpenaiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])
  end

  def get_completion(prompt, feedback)
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: SYSTEM_INTEL },
          { role: "user", content: prompt % feedback }
        ]
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
