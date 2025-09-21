require 'rails_helper'

RSpec.describe "Summaries", type: :request do
  before do
    # Stub OpenAI API so no real network call occurs
    stub_request(:post, /api.openai.com/).to_return(
      status: 200,
      body: {
        choices: [
          { message: { content: "- key point\nTLDR: one line" } }
        ]
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  it "creates a transcription and returns a summary" do
    # Create a transcription record
    t = Transcription.create!(text: "Hello this is a test. We are testing summary.", status: 'pending')

    # Call the summary endpoint
    get "/summary/#{t.id}"

    # Expect a successful response
    expect(response).to have_http_status(:ok)

    # Parse JSON response
    body = JSON.parse(response.body)

    # Expect the response to include a summary
    expect(body['summary']).to include("TLDR")

    # Reload transcription to check DB changes
    t.reload

    # Check that the summary is stored
    expect(t.summary).to be_present

    # Check that the transcription status is updated (summarized)
    expect(t.summarized?).to be true
  end
end
