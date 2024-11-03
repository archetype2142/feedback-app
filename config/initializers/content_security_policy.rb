Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https
  policy.style_src   :self, :https
  # If you're using webpack-dev-server in development:
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
end

# Generate nonce for scripts
Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }
