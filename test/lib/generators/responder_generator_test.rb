require 'test_helper'
require 'generators/responder/responder_generator'

class ResponderGeneratorTest < Rails::Generators::TestCase
  tests ResponderGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
