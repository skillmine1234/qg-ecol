class ChangeLengthOfReferenceNoInEcolVaMemoTxns < ActiveRecord::Migration
  def change
    change_column :ecol_va_memo_txns, :reference_no, :string, length: 32
  end
end
