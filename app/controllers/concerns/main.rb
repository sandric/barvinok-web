# frozen_string_literal: true

require 'base64'

# :nodoc:
module Main
  extend ActiveSupport::Concern

  def base64(file)
    Base64.encode64(file)
  end
end
