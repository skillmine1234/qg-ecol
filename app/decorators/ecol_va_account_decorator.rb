class EcolVaAccountDecorator < EcolOperationDecorator
  def hold_amount
    h.number_to_currency(object.hold_amount, unit: 'Rs ')
  end
  
  def account_balance
    h.number_to_currency(object.account_balance, unit: 'Rs ')
  end
end