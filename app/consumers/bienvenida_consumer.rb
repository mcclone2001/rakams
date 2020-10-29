# frozen_string_literal: true

# A generic karafka responder
class BienvenidaConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      # TO DO - Que debe hacer este consumer?
      Rails.logger.info('=====================================================')
      Rails.logger.info(message.to_json)
    end
  end
end
