# frozen_string_literal: true

# :nodoc:
module KeyboardsAccessor
  extend ActiveSupport::Concern

  def keyboard_names
    @keyboard_names ||= Dir.entries(Settings.instance.git_path).select do |f|
      File.directory?(File.join(Settings.instance.git_path, f)) &&
        !['.', '..'].include?(f)
    end
  end

  def current_keyboard_name
    @current_keyboard_name ||=
      File.read("#{Settings.instance.git_path}/.current-keyboard").rstrip
  end

  def switch_current_keyboard(keyboard_name)
    open("#{Settings.instance.git_path}/.current-keyboard", 'w') do |f|
      f << keyboard_name
    end

    @current_keyboard_name = keyboard_name
  end

  def current_keyboard
    return nil if current_keyboard_name.blank?

    @current_keyboard = Keyboard.new(current_keyboard_name,
                                     Settings.instance.git_path)
  end
end
