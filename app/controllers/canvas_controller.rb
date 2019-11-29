# frozen_string_literal: true

# :nodoc:
class CanvasController < ApplicationController
  include KeyboardsAccessor

  before_action :set_gon, only: :edit

  def index
    redirect_to action: :edit
  end

  def edit
    @rows_count = ENV['ROWS_COUNT'].to_i
    @columns_count = ENV['COLUMNS_COUNT'].to_i
  end

  private

  def canvas_commits_data
    current_keyboard&.git&.branches&.map do |branch|
      commits = current_keyboard.commits(branch).map do |c|
        { message: c.message,
          hash: c.objectish,
          preview_base64: base64(current_keyboard
                                   .git
                                   .show(c.objectish, 'preview.png')) }
      end

      [branch.name, commits]
    end.to_h
  end

  def set_gon
    gon.push(keyboards: keyboard_names,
             current_keyboard: current_keyboard_name,
             current_branch: current_keyboard&.current_branch,
             commits: canvas_commits_data,
             detached: current_keyboard&.current_branch&.starts_with?('HEAD detached'),
             layout: current_keyboard&.layout || [],
             code: current_keyboard&.code || '',
             button_defaults: current_keyboard&.button_defaults)
  end
end
