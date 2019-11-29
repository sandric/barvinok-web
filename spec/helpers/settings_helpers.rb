# frozen_string_literal: true

module SettingsHelpers
  SETTINGS_PATH = Rails.root.join('tmp/fixtures/')

  GIT_PATH = Rails.root.join('tmp/fixtures/barvinok_git').to_s
  GIT_USER_NAME = FFaker::Internet.user_name
  GIT_FIRST_NAME = FFaker::Name.first_name
  GIT_LAST_NAME = FFaker::Name.last_name
  GIT_SSH = FFaker::Lorem.characters

  extend self

  def regenerate_fixture
    set_env
    clear_config
    generate_config
  end

  def fixture_data
    JSON.parse(File.read("#{ENV['ROOT_DIR']}.barvinok.json"))
  end

  private

  def set_env
    ENV['ROOT_DIR'] = SETTINGS_PATH.to_s
  end

  def generate_config
    config = {
      git_path: GIT_PATH,
      git_user_name: GIT_USER_NAME,
      git_first_name: GIT_FIRST_NAME,
      git_last_name: GIT_LAST_NAME,
      git_ssh: GIT_SSH
    }

    Settings.update(config)
  end

  def clear_config
    FileUtils.rm_f(SETTINGS_PATH)
  end
end
