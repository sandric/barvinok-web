# frozen_string_literal: true

require 'rails_helper'

describe 'visits canvas', type: :feature do
  before :each do
  end

  it 'visits canvas' do
    skip
  end

  it 'populates selectors' do
    KeyboardsHelpers.add_and_select_fixture('test-kbd-1')
    KeyboardsHelpers.add_fixture('test-kbd-2')

    visit edit_canvas_path

    commits_names = KeyboardsHelpers.commits_names('test-kbd-1', 'branch-1')
    commits_options = KeyboardsHelpers.commits_options(page)

    branches_names = KeyboardsHelpers.branches_names('test-kbd-1')
    branches_options = KeyboardsHelpers.branches_options(page)

    keyboards_names = ['test-kbd-1', 'test-kbd-2']
    keyboards_options = KeyboardsHelpers.keyboards_options(page)

    expect(commits_names).to eq(commits_options)
    expect(branches_names).to eq(branches_options)
    expect(keyboards_names).to match_array(keyboards_options)
  end
end
