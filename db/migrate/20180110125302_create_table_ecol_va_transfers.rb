class CreateTableEcolVaTransfers < ActiveRecord::Migration
  def change
    create_table :ecol_va_transfers, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :account_no, :limit => 64, :null => false , :comment => "the virtual account no of a customer"
      t.string :external_req_no, :limit => 64, :null => false, :comment => "the unique payment request no which has come from the caller"
      t.datetime :req_timestamp, :null => false, :comment => "the timestamp at which the payment instruction was initiated"
      t.string :hold_no, :limit => 64, :null => false, :comment => "the unique number which has been used to put the hold on virtual account no"
      t.string :transfer_type, :limit => 10, :null => false, :comment => "the transfer type which has been used to process the transaction"
      t.number :transfer_amount, :null => false, :comment => "the amount which has to be transferred"
      t.string :bene_account_no, :limit => 64, :null => false, :comment => "the account number of the beneficiary"
      t.string :bene_account_ifsc, :limit => 20, :null => false, :comment => "the IFSC code of the beneficiary"
      t.string :bene_account_name, :limit => 255, :null => false, :comment => "the name of the beneficiary"
      t.string :rmtr_bene_note, :limit => 255, :null => false, :comment => "the note to the beneficiary from remitter"
      t.string :status_code, :limit => 20, :null => false, :comment => "the status of the payment"
      t.datetime :picked_at, :comment => "the timestamp at which the transfer record is picked up for further process "
      t.string :cbs_ref_no, :limit => 64, :comment => "the CBS request reference number, used for reconciliation of credits and debits with the real account number in the CBS"
      t.string :bank_ref_no, :limit => 64, :comment => "the unique bank reference number for the transfer"
      t.datetime :reconciled_at, :comment => "the timestamp at which the transfer is reconciled"
      t.datetime :confirmed_at, :comment => "the timestamp at which the transfer is confirmed"
      t.datetime :returned_at, :comment => "the timestamp at which the payment is returned incase of failure of transfer "
    end
    add_index :ecol_va_transfers, [:external_req_no], :unique => true, :name => :external_req_no_unique_index
  end
end
