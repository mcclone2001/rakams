class CreateTwilioNotification < ActiveRecord::Migration[6.0]
  def change
    create_table :twilio_notifications do |t|
      t.integer :referred_id
      t.string :referred, limit: 100
      t.string :notification_type, limit: 100
      t.string :sid
      t.string :status, limit: 100
      t.string :sender, limit: 100
      t.string :receiver, limit: 100
      t.text :body
      t.string :callback
      t.json :request
      t.json :response
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
