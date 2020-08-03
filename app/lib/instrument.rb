# frozen_string_literal: true

# Modulo para instrumentar
module Instrument
  extend ActiveSupport::Concern
  def class_name
    # https://stackoverflow.com/questions/19679969/get-caller-class/23282038#23282038
    (self.class == Class ? to_s : self.class.to_s).freeze
  end

  def instrument(name, payload)
    # https://stackoverflow.com/questions/5100299/how-to-get-the-name-of-the-calling-method
    ActiveSupport::Notifications.instrument(class_name + '.' + caller[0][/`.*'/][1..-2] + '.' + name, payload) do
      yield if block_given?
    end
  end
end

# https://www.geeksforgeeks.org/include-v-s-extend-in-ruby/
#
# class MyClass
#     include Instrument
#     extend Instrument
# end
#
# MyClass.instrument "nombre del evento", "payload"
