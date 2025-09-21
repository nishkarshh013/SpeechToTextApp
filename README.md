# README

A Ruby on Rails web application that allows users to record their voice, see a live transcription, and generate a summary of the conversation using OpenAI's language model (or a local fake summary in development/test).

Features:

Voice recording in the browser.

Real-time transcription (optional, depending on API choice).

Full transcription storage in the database.

Conversation summarization with LLM or local fake summaries for testing.

Simple REST API endpoints for managing transcriptions and summaries.

Built with Rails 7+, StimulusJS, Hotwire/Turbo optional.

Basic RSpec tests for the summarization endpoint.

Tech Stack:

Backend: Ruby on Rails 7+, PostgreSQL (or SQLite for dev/test)

Frontend: StimulusJS, plain JavaScript

Speech-to-Text: OpenAI Whisper, Deepgram, AssemblyAI, Google STT (configurable)

Summarization: OpenAI GPT-4o / GPT-3.5-turbo or a fake summary for tests

Testing: RSpec, WebMock (optional)



1. Clone the repository
git clone https://github.com/nishkarshh013/SpeechToTextApp
cd SpeechToTextApp

2. Install dependencies
bundle install

3. Setup environment variables
Create a .env file in the project root:
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4o-mini

4. Database setup
rails db:create
rails db:migrate

5. Start the server
rails server

6. Testing
bundle exec rspec