return if Feedback.count > 0

20.times do
  Feedback.create!(
    content: ['Great service!', 'Could be better', 'Having issues'].sample,
    source_page: ['/home', '/products', '/about'].sample,
    device_type: ['desktop', 'mobile', 'tablet'].sample,
    created_at: rand(24.hours).seconds.ago
  )
end

# Run seeds
rails db:seed
