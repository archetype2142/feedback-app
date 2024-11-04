# frozen_string_literal: true

module ApplicationHelper
 def emotion_score_color(score)
    case 
    when score >= 1.5
      'text-green-600' # Very positive
    when score >= 1
      'text-green-500' # Positive
    when score > -0.3
      'text-gray-600'  # Neutral
    when score > -1.5
      'text-red-500'   # Negative
    else
      'text-red-600'   # Very negative
    end
  end
end
