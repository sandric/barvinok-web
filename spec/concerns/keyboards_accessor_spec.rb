# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'keyboards_accessor_concern' do |parameters|
  let(:concernable) { described_class.new(*parameters) }

  it 'keyboard_names method returns blank keyboard names if none exist' do
    expect(concernable.keyboard_names).to be_empty
  end

  it 'keyboard_names method returns keyboard names' do
    KeyboardsHelpers
      .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
    KeyboardsHelpers.add_fixture(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

    expect(concernable.keyboard_names).to match(%w[test-kbd-2 test-kbd-1])
  end

  it 'current_keyboard_name method returns blank in none exist' do
    expect(concernable.current_keyboard_name).to be_empty
  end

  it 'current_keyboard_name method returns current keyboard name' do
    KeyboardsHelpers.add_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
    KeyboardsHelpers
      .add_and_select_fixture(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

    expect(concernable.current_keyboard_name)
      .to eq(KeyboardsHelpers::SECOND_KEYBOARD_NAME)
  end

  it 'switch_current_keyboard switches current keyboard' do
    KeyboardsHelpers.add_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
    KeyboardsHelpers
      .add_and_select_fixture(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

    expect(concernable.current_keyboard_name)
      .to eq(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

    concernable.switch_current_keyboard(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

    expect(concernable.current_keyboard_name)
      .to eq(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
  end

  it 'current_keyboard method returns nil if no keyboard selected' do
    expect(concernable.current_keyboard).to be_nil
  end

  it 'current_keyboard method returns selected keyboard' do
    KeyboardsHelpers
      .add_and_select_fixture(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

    expect(concernable.current_keyboard.name)
      .to eq(KeyboardsHelpers::SECOND_KEYBOARD_NAME)
  end
end
