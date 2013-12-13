Recaptcha.configure do |config|
  config.public_key  = '6LeptOsSAAAAADTXFik5B9TjKKxHjd336ABqaNK7'
  config.private_key = ENV["RECAPTCHA_PRIVATE_KEY"]
  config.use_ssl_by_default = true
end
