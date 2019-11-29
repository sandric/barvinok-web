# frozen_string_literal: true

# :nodoc:
class GitController < ApplicationController
  include KeyboardsAccessor

  skip_before_action :verify_authenticity_token

  def init
    CreateKeyboard.call(params[:keyboard], params[:commit]) do
      on(:ok) { logger.info("#{params[:keyboard]} keyboard created") }
    end
  end

  def destroy
    DestroyKeyboard.call(params[:keyboard]) do
      on(:ok) { logger.info("#{params[:keyboard]} keyboard destroyed") }
    end
  end

  def commit
    UpdateKeyboard.call(params[:commit], params[:commit][:message]) do
      on(:ok) { |hash| logger.info("Commit created - #{hash}") }
    end
  end

  def switch_keyboard
    switch_current_keyboard(params[:keyboard])
  end

  def switch_branch
    current_keyboard.git.checkout(params[:branch])
  end

  def checkout
    current_keyboard.git.checkout(params[:commit])
  end

  def create_branch
    current_keyboard.git.branch(params[:branch]).create
  end

  def delete_branch
    current_keyboard.git.branch(params[:branch]).delete
  end
end
