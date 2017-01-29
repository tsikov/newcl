require 'minitest/autorun'
require 'vcr'
require_relative 'newcl.rb'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
end

describe "fetch-repos" do
  it "should fetch latest CL repos" do
    VCR.use_cassette('vcr_cassettes') do
      result = fetch_repos
      assert_equal Array, result.class
      assert_equal 3, result.first.length
    end
  end
end
