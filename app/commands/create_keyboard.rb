# frozen_string_literal: true

# :nodoc:
class CreateKeyboard < Rectify::Command
  include Main
  include KeyboardsAccessor

  def initialize(name, commit)
    @name = name
    @commit = commit
  end

  def call
    Git.init("#{Settings.instance.git_path}/#{@name}")

    old_keyboard_name = current_keyboard_name
    switch_current_keyboard(@name)

    UpdateKeyboard.call(@commit, 'Initial commit.') do
      on(:ok) { |hash| Rails.logger.info("Commit created - #{hash}") }
    end

    switch_current_keyboard(old_keyboard_name) unless old_keyboard_name.blank?
    broadcast(:ok)
  end
end
