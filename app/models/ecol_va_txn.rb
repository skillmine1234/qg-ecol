class EcolVaTxn < ActiveRecord::Base
  include SearchAbility
  attr_searchable :customer_code, :account_no, :hold_no, :account_balance, :hold_amount, {txn_amount: :range}, {txn_timestamp: :range}
  
  def ecol_va_account
    EcolVaAccount.find_by("customer_code = ? and account_no = ?", self.customer_code, self.account_no)
  end

  def ecol_va_earmark
    EcolVaEarmark.find_by("customer_code = ? and account_no = ?", self.customer_code, self.account_no)
  end  

  def readonly?
    !Rails.env.test?
  end
end