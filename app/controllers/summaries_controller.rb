class SummariesController < ApplicationController
  # GET /summary/:id
  def show
    t = Transcription.find(params[:id])

    if t.summary.present?
      render json: { id: t.id, summary: t.summary, status: t.status }
      return
    end

    # Generate summary synchronously (for simplicity). For production, use background job.
    # summary = generate_summary(t.text)

    summary =
      if Rails.env.test? || Rails.env.development?
        "- key point\nTLDR: one line"
      else
        generate_summary(t.text)
      end

    t.update!(summary: summary, status: "summarized")
    render json: { id: t.id, summary: summary, status: t.status }
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def generate_summary(text)
    # Example using OpenAI. Require OPENAI_API_KEY in ENV.
    # This is a simple wrapper using HTTP; replace with your client library if you prefer.
    api_key = ENV["OPENAI_API_KEY"]
    raise "OpenAI API key missing" if api_key.blank?
    binding.pry
    prompt = <<~PROMPT
      Summarize the following conversation in 3–5 concise bullet points and a one-line TL;DR:

      Conversation:
      #{text}

      Output format:
      - bullets...
      TLDR: <one line>
    PROMPT

    # Use OpenAI Chat Completions (gpt-4o or gpt-4) or compatible; adapt model name as needed.
    response = HTTParty.post(
      "https://api.openai.com/v1/chat/completions",
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{api_key}"
      },
      body: {
        model: ENV.fetch("OPENAI_MODEL", "gpt-4o-mini"), # change as desired
        messages: [
          { role: "system", content: "You are a helpful assistant that summarizes conversations." },
          { role: "user", content: prompt }
        ],
        temperature: 0.2,
        max_tokens: 400
      }.to_json
    )

    if response.code != 200
      raise "LLM API error: #{response.body}"
    end

    body = JSON.parse(response.body)
    content = body.dig("choices", 0, "message", "content") || body.dig("choices", 0, "text")
    content.to_s.strip
  end
end
