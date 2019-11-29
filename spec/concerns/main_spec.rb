# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'main_concern' do |parameters|
  let(:concernable) { described_class.new(*parameters) }

  it 'has base64 method' do
    expect { concernable.base64('test') }.to_not raise_error
  end
end
