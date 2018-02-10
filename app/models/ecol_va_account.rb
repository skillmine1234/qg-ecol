class EcolVaAccount < ActiveRecord::Base
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  def readonly?
    !Rails.env.test?
  end
  
end