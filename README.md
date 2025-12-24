# Speech-to-Text App 🎙️

A Ruby on Rails web application that allows users to record their voice, see live transcription, and generate AI-powered conversation summaries.

![Ruby](https://img.shields.io/badge/Ruby-3.x-red)
![Rails](https://img.shields.io/badge/Rails-7+-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue)
![OpenAI](https://img.shields.io/badge/OpenAI-API-green)

## Overview

This application provides a seamless voice-to-text experience with intelligent conversation summarization powered by OpenAI's language models. Perfect for meeting notes, interviews, voice memos, and more.

---

## Features

- **Voice Recording** in the browser using Web Audio API
- **Real-time Transcription** (optional, depending on API choice)
- **Full Transcription Storage** in the database
- **AI-Powered Summarization** with OpenAI GPT models
- **Local Fake Summaries** for development and testing
- **REST API Endpoints** for managing transcriptions and summaries
- **Modern Frontend** with StimulusJS and Hotwire/Turbo
- **Comprehensive Testing** with RSpec

---

## Tech Stack

### Backend
- **Ruby on Rails** 7+
- **PostgreSQL** (or SQLite for dev/test)
- **RESTful API** architecture

### Frontend
- **StimulusJS** for interactive components
- **Hotwire/Turbo** (optional)
- **Vanilla JavaScript** for audio recording

### Speech-to-Text APIs (Configurable)
- OpenAI Whisper
- Deepgram
- AssemblyAI
- Google Speech-to-Text

### Summarization
- **OpenAI GPT-4o** / GPT-3.5-turbo
- Fake summary generator for tests

### Testing
- **RSpec** for unit and integration tests
- **WebMock** (optional) for API mocking

---

## Table of Contents

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Author](#author)

---

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby** 3.x or higher
- **Rails** 7+
- **PostgreSQL** (or SQLite for development)
- **Node.js** and **Yarn** (for asset compilation)
- **Bundler** gem
- **OpenAI API Key** (for production features)

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/nishkarshh013/SpeechToTextApp
cd SpeechToTextApp
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Setup Environment Variables

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4o-mini
```

**Note**: You can obtain an API key from [OpenAI Platform](https://platform.openai.com/api-keys)

### 4. Database Setup

```bash
rails db:create
rails db:migrate
```

**Optional**: Seed the database with sample data

```bash
rails db:seed
```

---

## Configuration

### Speech-to-Text Provider

Configure your preferred speech-to-text service in `config/initializers/speech_to_text.rb`:

```ruby
# Options: :openai_whisper, :deepgram, :assemblyai, :google_stt
Rails.application.config.stt_provider = :openai_whisper
```

### Summarization Settings

Adjust model and parameters in `config/initializers/openai.rb`:

```ruby
OpenAI.configure do |config|
  config.access_token = ENV['OPENAI_API_KEY']
  config.request_timeout = 30
end
```

---

## Running the Application

### Start the Development Server

```bash
rails server
```

The application will be available at `http://localhost:3000`

### Start the Rails Console

```bash
rails console
```

---

## API Endpoints

### Transcriptions

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/transcriptions` | List all transcriptions |
| POST | `/transcriptions` | Create new transcription |
| GET | `/transcriptions/:id` | Show specific transcription |
| DELETE | `/transcriptions/:id` | Delete transcription |

### Summaries

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/transcriptions/:id/summarize` | Generate summary for transcription |
| GET | `/transcriptions/:id/summary` | Get existing summary |

### Example Request

```bash
# Create transcription
curl -X POST http://localhost:3000/transcriptions \
  -H "Content-Type: application/json" \
  -d '{"text": "Your transcribed text here"}'

# Generate summary
curl -X POST http://localhost:3000/transcriptions/1/summarize
```

---

## Testing

### Run All Tests

```bash
bundle exec rspec
```

### Run Specific Test Files

```bash
# Test summarization endpoint
bundle exec rspec spec/requests/summarizations_spec.rb

# Test models
bundle exec rspec spec/models/
```

### Test Coverage

The test suite includes:

- Model validations and associations
- API endpoint functionality
- Summarization logic (with fake summaries)
- Audio recording integration
- Error handling

---

## Project Structure

```
SpeechToTextApp/
├── app/
│   ├── controllers/
│   │   ├── transcriptions_controller.rb
│   │   └── summaries_controller.rb
│   ├── models/
│   │   ├── transcription.rb
│   │   └── summary.rb
│   ├── services/
│   │   ├── speech_to_text_service.rb
│   │   └── summarization_service.rb
│   ├── javascript/
│   │   └── controllers/
│   │       └── recorder_controller.js
│   └── views/
│       └── transcriptions/
├── config/
│   ├── initializers/
│   │   ├── openai.rb
│   │   └── speech_to_text.rb
│   └── routes.rb
├── spec/
│   ├── models/
│   ├── requests/
│   └── services/
└── README.md
```

---

## 🔍 How It Works

### 1. Voice Recording

- User clicks "Record" button in the browser
- JavaScript captures audio using `MediaRecorder` API
- Audio is recorded in WebM or MP3 format

### 2. Speech-to-Text

- Recorded audio is sent to configured STT service
- Service returns text transcription
- Transcription is saved to database

### 3. Summarization

- User requests summary for transcription
- Text is sent to OpenAI GPT model
- AI-generated summary is returned and stored

### 4. Development Mode

- Uses fake summary generator for testing
- No API calls required during development
- Speeds up testing and development workflow

---

## Environment Variables

Create a `.env` file with the following variables:

```env
# Required
OPENAI_API_KEY=sk-your-openai-api-key-here
OPENAI_MODEL=gpt-4o-mini

# Optional (for other STT providers)
DEEPGRAM_API_KEY=your-deepgram-key
ASSEMBLYAI_API_KEY=your-assemblyai-key
GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json

# Database (if not using default)
DATABASE_URL=postgresql://user:password@localhost/dbname
```

---

## Troubleshooting

### Audio Recording Not Working

**Issue**: Browser doesn't request microphone permission

**Solution**: Ensure you're using HTTPS or `localhost`. Modern browsers require secure contexts for microphone access.

### OpenAI API Errors

**Issue**: `401 Unauthorized` or `429 Too Many Requests`

**Solution**: 
- Verify your API key in `.env`
- Check your OpenAI account billing status
- Implement rate limiting or retry logic

### Database Connection Issues

**Issue**: `PG::ConnectionBad`

**Solution**:
```bash
# Check PostgreSQL is running
brew services start postgresql  # macOS
sudo service postgresql start   # Linux

# Recreate database
rails db:drop db:create db:migrate
```

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## 🎓 Learning Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [StimulusJS Handbook](https://stimulus.hotwired.dev/)
- [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)

---

## Author

**Nishkarsh Sahu**  
Ruby on Rails Developer

📧 Email: nishkarshsahu007@gmail.com  
💼 LinkedIn: https://www.linkedin.com/in/nishkarsh-sahu-b54ba8193/  
🐙 GitHub: [@nishkarshh013](https://github.com/nishkarshh013)

---

## Acknowledgments

- OpenAI for GPT and Whisper APIs
- Rails community for excellent documentation
- Contributors and testers

---

## Project Status

 **Active Development**

Current Version: `1.0.0`

---

**Built with ❤️ using Ruby on Rails**