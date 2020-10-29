module TwilioHelpers
  class TwilioHelper
    def new_client
      Twilio::REST::Client.new(
        Rails.application.secrets.twilio_account_sid,
        Rails.application.secrets.twilio_auth_token
      )
    end

    def send_whatsapp(params, referred_id, referred_name, status_callback = nil)
      @from, @to, @body = params.values_at(:from, :to, :body)
      @to = @to.gsub(/\s+/, '')
      @response = if status_callback.present?
                    new_client.messages.create(from: "whatsapp:+#{@from}",
                                               to: "whatsapp:+#{@to}",
                                               body: @body,
                                               status_callback: status_callback)
                  else
                    new_client.messages.create(from: "whatsapp:+#{@from}",
                                               to: "whatsapp:+#{@to}",
                                               body: @body)
                  end
      log(referred_id, referred_name, 'whatsapp', status_callback)
      @response
    end

    private
    def log(referred_id, referred_name, type, callback)
      twilio_notification = TwilioNotification.new(
        referred_id: referred_id,
        referred: referred_name,
        notification_type: type,
        sid: @response.sid,
        status: @response.status,
        sender: @from,
        receiver: @to,
        body: @body,
        callback: callback,
        request: { from: @from, to: @to, body: @body }.to_json,
        response: @response.to_s
      )
      twilio_notification.save
    end
  end

  def self.verify_account_cellphone(account)
    twilio = TwilioHelper.new.new_client
    from = Rails.application.secrets.twilio_sender
    to = "+#{account.cellphone_country.country_code}#{account.cellphone}"
    body = I18n.t(
      'twilio_sms.account.verify_cellphone',
      token: account.cellphone_verification_token
    )
    twilio.messages.create(from: from, to: to, body: body)
  end

  def self.send_sms(phone_to, body)
    phone_to = phone_to.gsub(/\s+/, '')
    from = "+#{Rails.application.secrets.twilio_sender}"
    twilio = TwilioHelper.new.new_client
    twilio.messages.create(from: from, to: phone_to, body: body)
  end

  def self.send_whatsapp(phone_to, body)
    from = "whatsapp:+#{Rails.application.secrets.twilio_sender}"
    twilio = TwilioHelper.new.new_client
    twilio.messages.create(
      from: from,
      to: phone_to.gsub(/\s+/, ''),
      body: body,
      status_callback: Rails.application.secrets.twilio_status_callback
    )
  end

  def self.send_whatsapp_callback(phone_to, body, callback)
    from = "whatsapp:+#{Rails.application.secrets.twilio_sender}"
    twilio = TwilioHelper.new.new_client
    twilio.messages.create(
      from: from,
      to: phone_to.gsub(/\s+/, ''),
      body: body,
      status_callback: callback
    )
  end

  def self.send_whatsapp_with_fallback(receiver, body, referred_id, referred_name, callback)
    twilio = TwilioHelper.new
    params = { from: Rails.application.secrets.twilio_sender, to: receiver, body: body }
    twilio.send_whatsapp(params, referred_id, referred_name, callback)
  end
end