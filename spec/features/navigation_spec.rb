# frozen_string_literal: true

require 'rails_helper'

describe 'Navigation', type: :feature do
  before :each do
    visit '/'
  end

  it 'visits canvas editor on root' do
    expect(current_path).to eq(edit_canvas_path)
  end

  it 'visits canvas editor on Canvas url' do
    within('div.navbar-menu') { click_on 'Canvas' }
    sleep 2
    expect(current_path).to eq(edit_canvas_path)
  end

  it 'visits canvas editor on Legends url' do
    within('div.navbar-menu') { click_on 'Legends' }
    sleep 2
    expect(current_path).to eq(legends_path)
  end

  it 'visits canvas editor on Scratch url' do
    within('div.navbar-menu') { click_on 'Scratch' }
    sleep 2
    expect(current_path).to eq(scratch_index_path)
  end

  it 'visits canvas editor on Monitor url' do
    within('div.navbar-menu') { click_on 'Monitor' }
    sleep 2
    expect(current_path).to eq(monitor_index_path)
  end

  it 'visits canvas editor on Settings url' do
    within('div.navbar-menu') { click_on 'Settings' }
    sleep 2
    expect(current_path).to eq(edit_settings_path)
  end
end
