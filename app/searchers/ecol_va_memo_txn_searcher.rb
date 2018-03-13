class EcolVaMemoTxnSearcher < Searcher
  attr_searchable :account_no, :txn_type, {txn_amount: :range}
  
  as_enum :txn_type, [:CREDIT, :DEBIT], map: :string, source: :txn_type
end