class EcolVaEarmark < ActiveRecord::Base
  include SearchAbility
  attr_searchable :account_no, :hold_no, {hold_amount: :range}
  
  def ecol_va_account
    EcolVaAccount.find_by("customer_code = ? and account_no = ?", self.customer_code, self.account_no)
  end  
  
  def is_of_account?(ecol_va_account)
    self.customer_code == ecol_va_account.customer_code && self.account_no == ecol_va_account.account_no
  end
  
  def readonly?
    !Rails.env.test?
  end
  
end