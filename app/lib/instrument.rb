module Instrument
    extend ActiveSupport::Concern
  
    def log_prefix
      # https://stackoverflow.com/questions/19679969/get-caller-class/23282038#23282038
      @log_prefix ||= (self.class == Class ? "#{self.to_s}" : "#{self.class.to_s}").freeze
    end

    def instrument(name, payload)
        # https://stackoverflow.com/questions/5100299/how-to-get-the-name-of-the-calling-method
        ActiveSupport::Notifications.instrument log_prefix + "." + caller[0][/`.*'/][1..-2] + "." + name, payload do
            yield
        end
    end

end

=begin
https://www.geeksforgeeks.org/include-v-s-extend-in-ruby/

class MyClass
    include Instrument
    extend Instrument
end

MyClass.instrument "nombre del evento", "payload"

=end