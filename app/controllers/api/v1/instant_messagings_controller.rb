class Api::V1::InstantMessagingsController < ApplicationController
  include TwilioHelpers

  def create
    body, phone, referred_id, referred = params.values_at(:body, :phone, :referred_id, :referred)
    callback = "#{Rails.application.secrets.host}/api/v1/twilio_notifications"
    Rails.logger.info("==================================================================================")
    Rails.logger.info(callback)
    @response = TwilioHelpers.send_whatsapp_with_fallback(phone, body, referred_id, referred, callback)
    return error_response unless @response.error_code.zero?
    render json: { status: 'OK', message: 'whatsapp', data: twilio_notification.id }, status: 201
  end

  private
  def twilio_notification
    @twilio_notification ||= TwilioNotification
                             .where(sid: @response.sid).first
  end

  def error_response
    render json: { status: 'ERROR', message: 'whatsapp', data: twilio_notification },
           status: 422
  end
end
