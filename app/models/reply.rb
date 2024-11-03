class Reply < ApplicationRecord
  belongs_to :feedback
  validates :content, presence: true
  validates :sender_type, presence: true, inclusion: { in: ['user', 'system'] }
  
  scope :ordered, -> { order(created_at: :asc) }

  validate :reply_count

  def reply_count
    if self.sender_type == 'user'
      self.feedback.replies.where(sender_type: 'user').count > 1 ? errors.add(:base, "Cannot reply more than 2 times") : true
    end
  end
end
