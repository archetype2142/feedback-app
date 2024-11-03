class ActionItem < ApplicationRecord
  belongs_to :feedback
  
  enum status: {
    pending: 'pending',
    in_progress: 'in_progress',
    completed: 'completed'
  }

  enum priority: {
    low: 'low',
    medium: 'medium',
    high: 'high'
  }
end