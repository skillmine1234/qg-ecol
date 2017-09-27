class QgEcolTodaysUpiTxn < Upi

  validates_presence_of :rrn, :transfer_unique_no, :bene_account_ifsc, :bene_account_no, :rmtr_account_ifsc, :rmtr_account_no, :transfer_amt, 
                        :transfer_date, :pool_account_no

  validates :rrn, length: { maximum: 30 }
  validates :transfer_type, :error_code, length: { maximum: 3 }
  validates :transfer_status, length: { maximum: 25 }
  validates :transfer_unique_no, :rmtr_ref, :bene_account_no, :rmtr_account_no, length: { maximum: 64 }
  validates :bene_account_ifsc, :rmtr_account_ifsc, :pool_account_no, length: { maximum: 20 }
  validates :bene_account_type, :rmtr_account_type, length: { maximum: 10 }
  validates :transfer_ccy, length: { maximum: 5 }
  validates :status, length: { maximum: 4 }

  validates :bene_account_ifsc, :rmtr_account_ifsc, format: {with: /\A[A-Z|a-z]{4}[0][A-Za-z0-9]{6}+\z/, message: "invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}" }  
  validates_uniqueness_of :transfer_unique_no

  validates :transfer_amt, :numericality => { :less_than_or_equal_to => 100000 }

  before_save :set_default_values

  def set_default_values
    self.transfer_type = 'UPI'
    self.transfer_ccy = 'INR'
    self.transfer_status = 'NEW'
    self.status = 'C'
  end

end