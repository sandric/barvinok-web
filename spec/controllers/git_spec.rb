# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GitController, type: :controller do
  it_behaves_like 'main_concern'
  it_behaves_like 'keyboards_accessor_concern'

  let(:new_keyboard_name) { FFaker::Lorem.word }
  let(:new_commit_message) { FFaker::Lorem.sentence }
  let(:new_branch_name) { FFaker::Lorem.word }
  let(:checkout_commit_id) { 3 }

  describe 'POST init' do
    it 'creates new keyboard' do
      post :init, { params: {
                      keyboard: new_keyboard_name,
                      commit: KeyboardsHelpers::STUB_COMMIT_PARAMS
                    } }

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'DELETE destroy' do
    it 'destroys keyboard' do
      KeyboardsHelpers.add_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      expect(KeyboardsHelpers.list_fixtures)
        .to match([KeyboardsHelpers::FIRST_KEYBOARD_NAME])

      delete :destroy, { params: {
                           keyboard: KeyboardsHelpers::FIRST_KEYBOARD_NAME
                         } }

      expect(KeyboardsHelpers.list_fixtures).to be_empty
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST commit' do
    it 'creates new commit' do
      KeyboardsHelpers
        .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
      KeyboardsHelpers
        .commits_names(KeyboardsHelpers::FIRST_KEYBOARD_NAME,
                       KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[0])

      post :commit, { params: {
                        commit: KeyboardsHelpers::STUB_COMMIT_PARAMS
                          .merge(message: new_commit_message)
                      } }

      new_commit = KeyboardsHelpers
                     .commits_names(KeyboardsHelpers::FIRST_KEYBOARD_NAME,
                                    KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[0])
                     .first

      expect(new_commit).to eq(new_commit_message)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PUT checkout' do
    it 'checks out commit' do
      KeyboardsHelpers
        .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      keyboard = Keyboard.new(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      checked_hash = keyboard
                       .commits_hashes(KeyboardsHelpers::
                                         FIRST_KEYBOARD_BRANCH_NAMES[0])[checkout_commit_id]

      put :checkout, { params: { commit: checked_hash } }

      expect(assigns(:current_keyboard).current_branch)
        .to eq("(HEAD detached at #{checked_hash[0..6]})")

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PUT switch_keyboard' do
    it 'switches current keyboard' do
      KeyboardsHelpers
        .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)
      KeyboardsHelpers
        .add_fixture(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

      expect(KeyboardsHelpers.current_fixture_name)
        .to eq(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      put :switch_keyboard, { params: {
                                keyboard: KeyboardsHelpers::SECOND_KEYBOARD_NAME
                              } }

      expect(KeyboardsHelpers.current_fixture_name)
        .to eq(KeyboardsHelpers::SECOND_KEYBOARD_NAME)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PUT switch_branch' do
    it 'switches current branch' do
      KeyboardsHelpers
        .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      keyboard = Keyboard.new(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      expect(keyboard.current_branch)
        .to eq(KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[0])

      put :switch_branch, { params: {
                              branch: KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[1]
                            } }

      expect(assigns(:current_keyboard).current_branch)
        .to eq(KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[1])

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST create_branch' do
    it 'creates new branch' do
      KeyboardsHelpers
        .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      post :create_branch, { params: {
                               branch: new_branch_name
                             } }

      expect(KeyboardsHelpers.branches_names(KeyboardsHelpers::FIRST_KEYBOARD_NAME))
        .to match((KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES + [new_branch_name]).sort)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'DELETE delete_branch' do
    it 'destroys new branch' do
      KeyboardsHelpers
        .add_and_select_fixture(KeyboardsHelpers::FIRST_KEYBOARD_NAME)

      delete :delete_branch, { params: {
                                 branch: KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[1]
                               } }

      expect(KeyboardsHelpers.branches_names(KeyboardsHelpers::FIRST_KEYBOARD_NAME))
        .to match(KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES
                    .without(KeyboardsHelpers::FIRST_KEYBOARD_BRANCH_NAMES[1]))

      expect(response).to have_http_status(:no_content)
    end
  end
end
