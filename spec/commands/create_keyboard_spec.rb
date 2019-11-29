# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateKeyboard do
  it_behaves_like 'main_concern', %w[test-name test-commit]
  it_behaves_like 'keyboards_accessor_concern', %w[test-name test-commit]

  let(:new_keyboard_name) { 'test-kbd-3' }

  it 'creates new keyboard with initial commit' do
    expect(KeyboardsHelpers.list_fixtures).to be_empty

    expect(UpdateKeyboard).to receive(:call)
                                .with(KeyboardsHelpers::STUB_COMMIT_PARAMS,
                                      'Initial commit.')

    CreateKeyboard.call(new_keyboard_name, KeyboardsHelpers::STUB_COMMIT_PARAMS)

    expect(KeyboardsHelpers.list_fixtures).to match([new_keyboard_name])
  end
end
