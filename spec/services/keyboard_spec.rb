# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyboard do
  before :each do
    KeyboardsHelpers.add_and_select_fixture('test-kbd-1')
    KeyboardsHelpers.add_fixture('test-kbd-2')
  end

  it 'initialize new first Keyboard instance' do
    keyboard = Keyboard.new(KeyboardsHelpers::FIRST_KEYBOARD_NAME,
                            SettingsHelpers::GIT_PATH)

    expect(keyboard.name).to eq(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
    expect(keyboard.current_branch)
      .to eq(KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[0])
    expect(keyboard.path)
      .to eq("#{SettingsHelpers::GIT_PATH}/#{KeyboardsHelpers::FIRST_KEYBOARD_NAME}")
  end

  it 'initialize new second Keyboard instance' do
    keyboard = Keyboard.new(KeyboardsHelpers::SECOND_KEYBOARD_NAME,
                            SettingsHelpers::GIT_PATH)

    expect(keyboard.name).to eq(KeyboardsHelpers::SECOND_KEYBOARD_NAME)
    expect(keyboard.current_branch)
      .to eq(KeyboardsHelpers::SECOND_KEYBOARD_BRANCH_NAMES[0])
    expect(keyboard.path)
      .to eq("#{SettingsHelpers::GIT_PATH}/#{KeyboardsHelpers::SECOND_KEYBOARD_NAME}")
  end

  describe 'first keyboard' do
    let!(:keyboard) { Keyboard.new(KeyboardsHelpers::FIRST_KEYBOARD_NAME,
                                   SettingsHelpers::GIT_PATH) }

    let(:first_branch_commits_names) {
      ['test-kbd-1 branch-1 commit-4',
       'test-kbd-1 branch-1 commit-3',
       'test-kbd-1 master commit-2',
       'test-kbd-1 master commit-1',
       'Initial commit.']
    }

    let(:first_branch_commits_hashes) {
      ['7ca50fe020613251910fc24893814da3b2b80944',
       '86aa1146184d89e3a3e0c09029a53dd77cc05b60',
       'fbef5187c275771b9b4414cae6758613395311e9',
       'b46542745dd9f630e2a6a62814e18a743cd2ed4b',
       '1850f85c6aab9f988150d046462299b6563ca965']
    }

    it 'returns commits names' do
      expect(keyboard.commits_names(keyboard.current_branch))
        .to match(first_branch_commits_names)
    end

    it 'returns commits names' do
      expect(keyboard.commits_hashes(keyboard.current_branch))
        .to match(first_branch_commits_hashes)
    end

    it 'returns branches names' do
      expect(keyboard.branches_names)
        .to match(KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES)
    end
  end    
end
