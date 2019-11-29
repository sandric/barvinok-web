# frozen_string_literal: true

# :nodoc:
class UpdateKeyboard < Rectify::Command
  include KeyboardsAccessor

  def initialize(params, message)
    @code = params[:code]
    @layout = params[:layout]
    @button_defaults = params[:button_defaults]
    @svg = "<svg width=\"#{ENV['SVG_WIDTH']}\" height=\"#{ENV['SVG_HEIGHT']}\">#{params[:svg]}</svg>"

    @message = message
  end

  def call
    write_files
    create_preview

    current_keyboard.git.add(all: true)
    hash = current_keyboard.git.commit(@message)

    broadcast(:ok, hash)
  end

  private

  def write_files
    open("#{current_keyboard.path}/code.rb", 'w') { |f| f << @code }
    open("#{current_keyboard.path}/layout.json", 'w') { |f| f << @layout }
    open("#{current_keyboard.path}/button_defaults.json", 'w') { |f| f << @button_defaults }
    open("#{current_keyboard.path}/preview.svg", 'w') { |f| f << @svg }
  end

  def create_preview
    `inkscape -z --export-png=#{current_keyboard.path}/preview.png #{current_keyboard.path}/preview.svg`
  end
end
