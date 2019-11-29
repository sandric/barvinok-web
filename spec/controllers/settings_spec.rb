# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  it_behaves_like 'main_concern'

  let(:updated_git_user_name) { FFaker::Internet.user_name }
  let(:invalid_params) {{
                          settings: SettingsHelpers
                            .fixture_data
                            .merge('git_user_name' => '')
                        }}
  let(:valid_params) {{
                        settings: SettingsHelpers
                          .fixture_data
                          .merge('git_user_name' => updated_git_user_name)
                      }}

  describe 'GET edit' do
    it 'renders the edit template' do
      get :edit

      expect(response).to render_template('edit')
    end
  end

  describe 'PUT update' do
    it 'checks falsey params - renders the edit template with error' do
      expect_any_instance_of(SettingsForm).to receive(:save).and_return(false)

      put :update, { params: invalid_params }

      expect(assigns(:settings_form).valid?).to be_falsey
      expect(response).to render_template('edit')
    end

    it 'checks truthy params - renders the edit template without error' do
      expect_any_instance_of(SettingsForm).to receive(:save).and_return(true)

      put :update, { params: valid_params }

      expect(assigns(:settings_form).valid?).to be_truthy
      expect(response).to redirect_to(edit_settings_path)
    end
  end
end
