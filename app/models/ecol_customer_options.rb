module EcolCustomerOptions
  extend ActiveSupport::Concern
  included do
    def self.options_for_val_method
      [['None','N'],['Web Service','W'],['Database Lookup','D']]
    end
  
    def self.options_for_acct_tokens
      [['None','N'],['Sub Code','SC'],['Remitter Code','RC'],['Invoice Number','IN']]
    end
    
    def self.options_for_customer_alert
      [['Always','A'],['On Credit','P'],['On Return','R'],['Never','N']]
    end

    def self.options_for_file_upld_mthd
      [['None','N'],['Full', 'F'],['Incremental','I']]
    end
  
    def self.options_for_nrtv_sufxs
      [['None','N'],['Sub Code','SC'],['Remitter Code','RC'],['Invoice Number','IN'],['Remitter Name','RN'],['Original Remitter Name','ORN'],['Original Remitter Account','ORA'],['Transfer Unique No','TUN'],['User Defined Field 1','UDF1'],['User Defined Field 2','UDF2']]
    end
  
    def self.options_for_rmtr_alert_on
      [['Never','N'],['On Pass','P'],['On Return','R'],['Always','A']]
    end
  
    def self.options_for_val_txn_date
      [['None','N'],['Exact','E'],['Range','R']]
    end
  
    def self.options_for_val_txn_amt
      [['None','N'],['Exact','E'],['Range','R'],['Percentage','P']]
    end
  end
end