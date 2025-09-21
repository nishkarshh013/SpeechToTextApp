class TranscriptionsController < ApplicationController
  protect_from_forgery with: :null_session, only: [ :create ] # because JS posts JSON

  def new
    # renders app/views/transcriptions/new.html.erb
  end

  def create
    # Expect JSON: { text: "full transcript..." }
    transcription_text = params[:text] || (request.body.read.present? && JSON.parse(request.body.read)["text"] rescue nil)
    if transcription_text.blank?
      render json: { error: "No text provided" }, status: :unprocessable_entity
      return
    end

    t = Transcription.create!(text: transcription_text, status: "pending")
    render json: { id: t.id, text: t.text }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
  end

  def show
    t = Transcription.find(params[:id])
    render json: { id: t.id, text: t.text, summary: t.summary, status: t.status }
  end
end
