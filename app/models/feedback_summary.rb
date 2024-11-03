class FeedbackSummary < ApplicationRecord
  validates :timeframe, presence: true
  validates :content, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
