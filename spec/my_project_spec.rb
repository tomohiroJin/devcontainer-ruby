# frozen_string_literal: true

require 'my_project'

RSpec.describe MyProject do
  it 'returns a hello message' do
    expect(described_class.hello).to eq('Hello, Ruby!')
  end
end
