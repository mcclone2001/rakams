class ApplicationRecord < ActiveRecord::Base
  acts_as_paranoid
  after_initialize :generate_uuid

  def generate_uuid
      self.id ||= SecureRandom.uuid
  end
  
  self.abstract_class = true
end
