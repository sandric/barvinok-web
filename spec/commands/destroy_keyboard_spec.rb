# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DestroyKeyboard do
  it 'destroys keyboard by name' do
    KeyboardsHelpers.add_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

    expect(KeyboardsHelpers.list_fixtures)
      .to match([KeyboardsHelpers::FIRST_KEYBOARD_NAME])

    DestroyKeyboard.call(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

    expect(KeyboardsHelpers.list_fixtures).to be_empty
  end
end
