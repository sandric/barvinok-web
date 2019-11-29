# frozen_string_literal: true

Rails.application.routes.draw do
  resources :canvas, only: [:index] do
    get 'edit', on: :collection
  end

  resources :legends, only: [:index]
  resources :scratch, only: [:index]
  resources :monitor, only: [:index]

  get 'settings/edit', as: 'edit_settings'
  put 'settings/update', as: 'update_settings'

  post 'git/init'
  delete 'git/destroy'
  put 'git/switch_keyboard'
  post 'git/create_branch'
  put 'git/switch_branch'
  delete 'git/delete_branch'
  post 'git/commit'
  put 'git/checkout'

  root to: 'canvas#index'
end
