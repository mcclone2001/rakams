class TwilioNotification < ActiveRecord::Base
  def delivered?
    status == 'delivered'
  end

  def failed?
    status == 'failed'
  end

  def readed?
    status == 'read'
  end

  def undelivered?
    status == 'undelivered'
  end
end
