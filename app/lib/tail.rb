# frozen_string_literal: true

class Tail
  attr_accessor :filename, :fd
  attr_reader :mtime, :size

  def initialize(filename)
    @filename = filename
    @stopped = false
  end

  def initialize_fd
    @fd ||= File.open(filename)
    update_stats
  end

  def read(num = 10, bytes = false)
    initialize_fd
    pos = 0
    current_num = 0

    loop do
      pos -= 1
      fd.seek(pos, IO::SEEK_END)
      char = fd.read(1)

      current_num += 1 if bytes || eol?(char)

      break if current_num > num || fd.tell.zero?
    end

    update_stats
    fd.read
  end

  def read_all
    update_stats
    fd.read
  end

  def file_changed?
    mtime != fd.stat.mtime || size != fd.size
  end

  def stopped?
    @stopped
  end

  def stop
    @stopped = true
  end

  private

  def eol?(char)
    char == "\n"
  end

  def update_stats
    @mtime = fd.stat.mtime
    @size = fd.size
  end
end
