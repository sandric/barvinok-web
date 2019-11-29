# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings, type: :model do
  let(:updated_git_first_name) { FFaker::Name.first_name }
  let(:updated_git_last_name) { FFaker::Name.last_name }

  it 'assigns singleton instance from settings file' do
    settings = Settings.instance

    %w[git_path git_user_name git_first_name git_last_name git_ssh].each do |f|
      expect(settings.instance_variable_get("@#{f}"))
        .to eq(SettingsHelpers.const_get(f.upcase))
    end
  end

  it 'updates settings file on update' do
    settings = Settings.instance

    Settings.update(git_first_name: updated_git_first_name,
                    git_last_name: updated_git_last_name)

    expect(settings.attributes['git_first_name'])
      .to eq(updated_git_first_name)
    expect(settings.attributes['git_last_name'])
      .to eq(updated_git_last_name)

    expect(SettingsHelpers.fixture_data['git_first_name'])
      .to eq(updated_git_first_name)
    expect(SettingsHelpers.fixture_data['git_last_name'])
      .to eq(updated_git_last_name)
  end
end
