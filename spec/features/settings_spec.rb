# frozen_string_literal: true

require 'rails_helper'

describe 'visit settings', type: :feature do
  let(:test_name) { FFaker::Name.name }

  before :each do
    visit '/settings/edit'
  end

  it 'checks settings navigation' do
    expect(page).to have_content 'Git Directory'
  end

  it 'checks validation', js: true do
    %w[git_user_name git_path].each do |field|
      expect(find_field(id: "settings_#{field}")[:class])
        .not_to include('is-danger')
      fill_in "settings_#{field}", with: ''
      click_on 'Update'
      sleep 2
      expect(find_field(id: "settings_#{field}")[:class])
        .to include('is-danger')
    end
  end

  it 'updates settings', js: true do
    expect(find_field(id: 'settings_git_first_name').value).not_to eq(test_name)
    fill_in 'settings_git_first_name', with: test_name
    click_on 'Update'
    page.driver.browser.navigate.refresh
    expect(find_field(id: 'settings_git_first_name').value).to eq(test_name)
  end
end
