class CreateTranscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :transcriptions do |t|
      t.text :text
      t.text :summary
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
