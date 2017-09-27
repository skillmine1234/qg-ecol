class Upi < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "upi_#{Rails.env}"
end