# frozen_string_literal: true

# :nodoc:
class LegendsController < ApplicationController
  include KeyboardsAccessor

  before_action :set_gon, only: :index

  def index; end

  private

  def legends_commits_data(git)
    commits = git.branches.map do |branch|
      commits = current_keyboard.commits(branch).map do |c|
        { message: c.message,
          hash: c.objectish,
          layout: JSON.parse(git.show(c.objectish, 'layout.json')),
          preview_base64: base64(git.show(c.objectish, 'preview.png'))
        }
      end

      [branch.name, commits]
    end.to_h
  end

  def keyboards_data
    keyboard_names.map do |keyboard|
      git = Git.open("#{Settings.instance.git_path}/#{keyboard}",
                     log: Logger.new('/dev/null'))
      [keyboard, legends_commits_data(git)]
    end.to_h
  end

  def set_gon
    gon.push(keyboards: keyboards_data,
             current_keyboard: current_keyboard_name,
             current_branch: current_keyboard&.current_branch)
  end
end
