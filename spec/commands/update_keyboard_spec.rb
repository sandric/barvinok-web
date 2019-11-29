# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateKeyboard do
  it_behaves_like 'keyboards_accessor_concern',
                  [KeyboardsHelpers::STUB_COMMIT_PARAMS, 'stub-message']

  let(:new_commit_message) { 'New commit test message' }

  it 'updates keyboard with new commit' do
    KeyboardsHelpers
      .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

    UpdateKeyboard.call(KeyboardsHelpers::STUB_COMMIT_PARAMS,
                        new_commit_message)

    commit = KeyboardsHelpers
               .commits_names(KeyboardsHelpers::FIRST_KEYBOARD_NAME,
                              KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[0])

    keyboard = Keyboard.new(KeyboardsHelpers::FIRST_KEYBOARD_NAME,
                            KeyboardsHelpers::GIT_DIRECTORY)

    expect(commit.first).to eq(new_commit_message)
    expect(keyboard.code).to eq('code-stub')
    expect(keyboard.layout).to match({ 'layout-stub' => 0 })
    expect(keyboard.button_defaults).to match({ 'button-defaults-stub' => 0 })
  end
end
