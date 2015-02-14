require 'spec_helper'
require 'enquiry/utils'

describe Enquiry::Utils do
  context '#symbolize_keys' do
    it "converts a hash's keys to symbols" do
      input = { 'one' => 1, 'two' => 2, 'nested' => { 'three' => 3 } }
      expected_output = { :one => 1, :two => 2, :nested => { :three => 3 } }
      expect(Enquiry::Utils.symbolize_keys(input)).to eq expected_output
    end
  end
end
