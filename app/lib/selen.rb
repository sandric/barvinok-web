require 'selenium-webdriver'

module Selen
  def self.setup
    @driver = Selenium::WebDriver.for(:remote, :url => 'http://localhost:4445/wd/hub', :desired_capabilities => :chrome)
    #@driver = Selenium::WebDriver.for :chrome
    @base_url = "http://www.google.com/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
end
