# frozen_string_literal: true

class MonitorChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'monitor_channel'

    # options = OpenStruct.new(
    #   verbose: false,
    #   follow: true,
    #   num_lines: 10,
    #   bytes: false
    # )

    # @tail = ::Tail.new("#{ENV['ROOT_DIR']}.barvinok.log")
    # original_entries = @tail.read(options[:num_lines], options[:bytes])
    # ActionCable.server.broadcast 'monitor_channel', message: original_entries

    # if options[:follow]
    #   while !@tail.stopped?
    #     if @tail.file_changed?
    #       new_entries = @tail.read_all
    #       ActionCable.server.broadcast 'monitor_channel', message: new_entries
    #     end
    #     sleep(1)
    #   end
    # end
  end

  def unsubscribed
    # @tail.stop
  end
end
