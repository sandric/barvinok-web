# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LegendsController, type: :controller do
  it_behaves_like 'main_concern'
  it_behaves_like 'keyboards_accessor_concern'

  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
