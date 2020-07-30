class ApplicationRecord < ActiveRecord::Base
  acts_as_paranoid
  after_initialize :generate_id

  def generate_id
      self.id ||= Id.generate
  end
  
  self.abstract_class = true

  include Instrument
  extend Instrument

end
