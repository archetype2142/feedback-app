class CreateReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :replies do |t|
      t.references :feedback, null: false, foreign_key: true
      t.text :content, null: false
      t.string :sender_type, null: false, default: 'user' # 'user' or 'system'
      t.timestamps
    end
  end
end
