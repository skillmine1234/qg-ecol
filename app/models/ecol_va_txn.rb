class EcolVaTxn < ActiveRecord::Base
  include SearchAbility
  attr_searchable :account_no, :hold_no, :account_balance, :hold_amount, {txn_amount: :range}, {txn_timestamp: :range}

  def readonly?
    if Rails.env.test?
      false
    else
      false
    end
  end
end