require "test_helper"
require "generators/hoge/hoge_generator"

class HogeGeneratorTest < Rails::Generators::TestCase
  tests HogeGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
