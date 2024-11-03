# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.string :status, default: 'new'

      t.timestamps
    end
  end
end
