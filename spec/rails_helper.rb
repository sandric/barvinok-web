require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

Object.send(:remove_const, :ActiveRecord)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end

require 'rspec/rails'
require 'selenium/webdriver'
require 'webdrivers/chromedriver'
require 'capybara'

Dir[Rails.root.join('spec', 'helpers', '**', '*.rb')].each { |f| require f }
Dir[Rails.root.join('spec', 'concerns', '**', '*.rb')].each { |f| require f }

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[no-sandbox headless disable-gpu window-size=1280,1024]
    }
  )

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_preference(:download,
                         prompt_for_download: false,
                         default_directory: DownloadHelpers::PATH.to_s)

  options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

  driver = Capybara::Selenium::Driver.new(app,
                                          browser: :chrome,
                                          desired_capabilities: capabilities,
                                          options: options)

  bridge = driver.browser.send(:bridge)

  path = '/session/:session_id/chromium/send_command'
  path[':session_id'] = bridge.session_id

  bridge.http.call(:post, path,
                   cmd: 'Page.setDownloadBehavior',
                   params: {
                     behavior: 'allow',
                     downloadPath: DownloadHelpers::PATH.to_s
                   })

  driver
end

Capybara.default_driver = Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 10

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:each) do
    SettingsHelpers.regenerate_fixture
    DownloadHelpers.clear_downloads
    KeyboardsHelpers.clear_fixtures
  end
end
