# frozen_string_literal: true

require 'rails_helper'

describe 'visits legends', type: :feature do
  let(:filter_buttons) do
    ['All', 'Only Background', 'Only Title', 'Only Subtitle']
  end
  let(:export_buttons) { ['Export Left to PNG', 'Export Right to PNG'] }

  before :each do
  end

  it 'visits legends' do
    visit legends_path

    (filter_buttons + export_buttons).each do |button|
      expect(page).to have_button button
    end
  end

  it 'populates selectors' do
    KeyboardsHelpers.add_and_select_fixture('test-kbd-1')
    KeyboardsHelpers.add_fixture('test-kbd-2')

    visit legends_path

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

  it 'exports png' do
    KeyboardsHelpers.add_and_select_fixture('test-kbd-1')

    visit legends_path

    selected_commit_hash_option = KeyboardsHelpers.selected_commit_hash_option_compact(page)
    selected_branch_option = KeyboardsHelpers.selected_branch_option(page)
    selected_keyboard_option = KeyboardsHelpers.selected_keyboard_option(page)

    %w[left right].each do |side|
      DownloadHelpers.clear_downloads
      click_on "Export #{side.titleize} to PNG"
      sleep 2

      expect(DownloadHelpers.first_download_name).to(
        eq("#{selected_keyboard_option}_#{selected_branch_option}_#{selected_commit_hash_option}_all_#{side}.png")
      )
    end
  end
end
