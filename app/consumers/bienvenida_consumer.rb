# frozen_string_literal: true

# A generic karafka responder
class BienvenidaConsumer < ApplicationConsumer
  include TwilioHelpers

  def consume
    params_batch.each do |message|
      # TO DO - Que debe hacer este consumer?
      Rails.logger.info('=====================================================')
      Rails.logger.info(message.to_json)
      callback = "#{Rails.application.secrets.host}/api/v1/twilio_notifications"
      body = 'Tu código de verificación de Nimbo es: 000. <Mensaje automático. No responder>'
      @response = TwilioHelpers.send_whatsapp_with_fallback('529612724148', body, '123', 'Person', callback)
    end
  end
end
