# frozen_string_literal: true

module DownloadHelpers
  TIMEOUT = 1
  PATH = Rails.root.join('tmp/downloads')

  extend self

  def downloads
    Dir[PATH.join('*')]
  end

  def download_names
    downloads.map { |p| p.gsub("#{PATH}/", '') }
  end

  def first_download_name
    download_names.first
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    downloads.grep(/\.part$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
end
