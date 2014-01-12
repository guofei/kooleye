I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
I18n.enforce_available_locales = true
I18n.default_locale = :ja
