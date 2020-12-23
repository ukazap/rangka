gem 'action_policy'
gem 'administrate'
gem 'rodauth-rails'

gem_group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  # gem 'capybara'
  # gem 'webdrivers'
  gem 'faker'
end

initializer 'generators.rb', <<-CODE
  Rails.application.config.generators do |g|
    g.test_framework :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      request_specs: false,
      controller_specs: false
  end
CODE

after_bundle do
  run 'rm -rf test'
  generate 'rspec:install'
  
  generate 'controller', 'home', 'index', '--skip-routes', '--no-helper'
  route "root to: 'home#index'"

  generate 'action_policy:install'

  rails_command 'db:setup'
  rails_command 'db:migrate'

  generate 'administrate:install'
  run "echo '//= link administrate/application.css' >> app/assets/config/manifest.js"
  run "echo '//= link administrate/application.js' >> app/assets/config/manifest.js"

  generate 'rodauth:install'
  rails_command 'db:migrate'
end