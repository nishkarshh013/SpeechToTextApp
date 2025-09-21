class Transcription < ApplicationRecord
    validates :text, presence: true

    enum :status, { pending: 0, summarized: 1 }
end
