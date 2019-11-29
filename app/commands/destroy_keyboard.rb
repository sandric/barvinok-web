# frozen_string_literal: true

# :nodoc:
class DestroyKeyboard < Rectify::Command
  def initialize(name)
    @name = name
  end

  def call
    FileUtils.rm_rf("#{Settings.instance.git_path}/#{@name}")
    broadcast(:ok)
  end
end
