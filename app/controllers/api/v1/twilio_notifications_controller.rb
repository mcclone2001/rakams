class Api::V1::TwilioNotificationsController < ApplicationController
  include TwilioHelpers

  def create
    @notification = TwilioNotification.new(twilio_notification_params)
    return error_response unless @notification.save
    return send_sms if @notification.failed? || @notification.undelivered?
    render json: { status: 'OK', message: 'whatsapp', data: nil }, status: 201
  end

  def send_whatsapp
    body, phone, referred_id, referred = params.values_at(:body, :phone, :referred_id, :referred)
    callback = "#{Rails.application.secrets.host}/api/v1/twilio_notifications"
    response = TwilioHelpers.send_whatsapp_with_fallback(phone, body, referred_id, referred, callback)
    return error_response unless response.error_code.zero?
    render json: { status: 'OK', message: 'whatsapp', data: nil }, status: 201
  end

  private
  def send_sms
    response = TwilioHelpers
               .send_sms("+#{@twilio_notification.receiver}", @twilio_notification.body)
    if response.error_code.zero?
      render json: { status: 'OK', message: 'sms', data: nil }, status: 201
    else
      error_response
    end
  rescue
    error_response
  end

  def twilio_notification
    @twilio_notification ||= TwilioNotification
                             .where(sid: params['MessageSid'],
                                    notification_type: 'whatsapp').first
  end

  def twilio_notification_params
    {
      referred_id: twilio_notification.referred_id,
      referred: twilio_notification.referred,
      notification_type: params['ChannelPrefix'],
      sid: params['MessageSid'],
      status: params['MessageStatus'],
      request: params.to_json,
      sender: twilio_notification.sender,
      receiver: twilio_notification.receiver,
      body: twilio_notification.body,
      callback: twilio_notification.callback,
      response: 'processing'
    }
  end

  def error_response
    render json: { status: 'ERROR', message: 'whatsapp', data: @twilio_notification },
           status: 422
  end

  def filtered_params
    params.except(:format, :controller, :action)
  end

  def validate_twilio_authenticity
    return false unless request.headers['X-Twilio-Signature'].present?
    url = @twilio_notification.callback
    sorted_params = filtered_params.sort.to_h
    twilio_signature = request.headers['X-Twilio-Signature']
    validator = Twilio::Security::RequestValidator.new(
      Rails.application.secrets.twilio_auth_token
    )

    validator.validate(url, sorted_params, twilio_signature)
  end

  def validate_request
    error_response unless twilio_notification.present? && validate_twilio_authenticity
  end
end
