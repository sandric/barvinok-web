# frozen_string_literal: true

require 'singleton'

# :nodoc:
class Settings
  include ActiveModel::Model
  include Singleton

  attr_accessor :git_path,
                :git_user_name,
                :git_first_name,
                :git_last_name,
                :git_ssh

  def attributes
    instance_values
  end

  def initialize
    settings_hash = JSON.parse(File.read("#{ENV['ROOT_DIR']}.barvinok.json"))
    super(settings_hash)
  end

  def self.update(settings_hash)
    instance.assign_attributes(settings_hash)
    json_settings = JSON.pretty_generate(instance.attributes)
    open("#{ENV['ROOT_DIR']}.barvinok.json", 'w') { |f| f << json_settings }
  end
end
