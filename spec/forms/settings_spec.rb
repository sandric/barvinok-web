# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SettingsForm, type: :model do
  let(:updated_git_user_name) { FFaker::Internet.user_name }
  let(:invalid_params) {{
                          settings: SettingsHelpers
                            .fixture_data
                            .merge('git_user_name' => '')
                        }}
  let(:valid_params) {{
                        settings: SettingsHelpers
                          .fixture_data
                          .merge('git_user_name' => updated_git_user_name)
                      }}

  it 'checks validity of default instance form' do
    form = SettingsForm.from_model(Settings.instance)

    expect(form.valid?).to be_truthy
  end

  it 'check form falsey validation' do
    form = SettingsForm.from_params(invalid_params)

    expect(form.valid?).to be_falsey
    expect(form.errors.messages).to match(git_user_name: ["can't be blank"])
  end

  it 'check form successful validation' do
    form = SettingsForm.from_params(valid_params)

    expect(form.valid?).to be_truthy
  end

  it 'check form falsey saving' do
    form = SettingsForm.from_params(invalid_params)

    expect(Settings).not_to receive(:update)
    expect(form.save).to be_falsey
  end

  it 'check form successful saving' do
    form = SettingsForm.from_params(valid_params)

    expect(Settings).to receive(:update)
    expect(form.save).to be_truthy
  end
end
