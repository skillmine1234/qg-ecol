class QgEcolTodaysImpsTxn < Atom

  validates_presence_of :rrn, :transfer_unique_no, :bene_account_ifsc, :bene_account_no, :rmtr_account_ifsc, :rmtr_account_no, :transfer_amt, :transfer_date, :pool_account_no, :status

  validates :bene_account_ifsc, :rmtr_account_ifsc, format: {with: /\A[A-Z|a-z]{4}[0][A-Za-z0-9]{6}+\z/, message: "invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}" }  
  validates_uniqueness_of :rrn, :transfer_unique_no

  validates :transfer_amt, :numericality => { :less_than_or_equal_to => 200000 }

  before_save :set_default_values

  def set_default_values
    self.transfer_type = 'IMPS'
    self.transfer_ccy = 'INR'
  end

end
