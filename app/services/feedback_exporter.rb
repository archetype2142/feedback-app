class FeedbackExporter
  def self.to_excel(feedbacks)
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Feedbacks") do |sheet|
      # Add headers
      sheet.add_row [
        "ID", "Content", "Sentiment", "Source", "Created At",
        "Keywords", "Status", "Priority"
      ]

      # Add data
      feedbacks.each do |feedback|
        sheet.add_row [
          feedback.id,
          feedback.content,
          feedback.sentiment,
          feedback.source_page,
          feedback.created_at,
          feedback.keywords.join(", "),
          feedback.status,
          feedback.priority
        ]
      end
    end

    package
  end
end
