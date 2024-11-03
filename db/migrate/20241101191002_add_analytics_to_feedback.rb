class AddAnalyticsToFeedback < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :sentiment_score, :float
    add_column :feedbacks, :sentiment, :string
    add_column :feedbacks, :source_page, :string
    add_column :feedbacks, :browser, :string
    add_column :feedbacks, :platform, :string
    add_column :feedbacks, :device_type, :string
    add_column :feedbacks, :suggested_action, :text
  end
end
