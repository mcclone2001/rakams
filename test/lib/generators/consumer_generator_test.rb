require 'test_helper'
require 'generators/consumer/consumer_generator'

class ConsumerGeneratorTest < Rails::Generators::TestCase
  tests ConsumerGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
