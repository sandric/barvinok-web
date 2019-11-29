# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CanvasController, type: :controller do
  it_behaves_like 'main_concern'
  it_behaves_like 'keyboards_accessor_concern'

  describe 'GET index' do
    it 'redirects to index' do
      get :index
      expect(response).to redirect_to(:edit_canvas)
    end
  end

  describe 'GET edit' do
    it 'redirects to index' do
      get :edit
      expect(response).to render_template('edit')
    end
  end
end
