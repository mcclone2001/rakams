# frozen_string_literal: true

# Application responder from which all Karafka responders should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationResponder < Karafka::BaseResponder
  include Instrument
  extend Instrument

  # This method needs to be implemented in each of the responders
  # def respond(data)
  #   respond_to :topic, data.to_json
  # end
end
