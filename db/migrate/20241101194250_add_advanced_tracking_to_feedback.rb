class AddAdvancedTrackingToFeedback < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :keywords, :string, array: true, default: []
    add_column :feedbacks, :cluster_id, :integer
    add_column :feedbacks, :assigned_to, :string
    add_column :feedbacks, :due_date, :datetime
    add_column :feedbacks, :priority, :string
    add_column :feedbacks, :referrer, :string
    add_column :feedbacks, :user_session_id, :string
    add_column :feedbacks, :page_title, :string
    add_column :feedbacks, :utm_source, :string
    add_column :feedbacks, :utm_medium, :string
    add_column :feedbacks, :utm_campaign, :string
  end

  create_table :feedback_clusters do |t|
    t.string :name
    t.text :description
    t.jsonb :keywords
    t.timestamps
  end

  create_table :action_items do |t|
    t.references :feedback, foreign_key: true
    t.string :title
    t.text :description
    t.string :status
    t.string :assigned_to
    t.datetime :due_date
    t.string :priority
    t.timestamps
  end
end
