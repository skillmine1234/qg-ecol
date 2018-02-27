require "qg/ecol/engine"

module Qg
  module Ecol
    NAME = 'ECollect'
    GROUP = 'e-collect'
    MENU_ITEMS = [:ecol_app, :ecol_customer, :ecol_remitter, :ecol_transaction, :udf_attribute, :ecol_summary, :ecol_va_memo_txn]
    MODELS = ['EcolRule','EcolCustomer','EcolRemitter','EcolTransaction','UdfAttribute','IncomingFile','EcolFetchStatistic','QgEcolTodaysNeftTxn',
              'QgEcolTodaysRtgsTxn','QgEcolTodaysImpsTxn','QgEcolTodaysUpiTxn','OutgoingFile','EcolApp','EcolAppUdtable','EcolSummary','EcolVaTxn',
              'EcolVaAccount','EcolVaEarmark','EcolVacdIncomingFile','EcolVacdIncomingRecord','IncomingFileRecord','EcolVaMemoTxn','EcolVaTransfer',
              'EcolIncomingFile','EcolIncomingRecord']
    TEST_MENU_ITEMS = [:qg_ecol_todays_neft_txn, :qg_ecol_todays_rtgs_txn, :qg_ecol_todays_imps_txn, :qg_ecol_todays_upi_txn]
    COMMON_MENU_ITEMS = [:incoming_file, :outgoing_file]
    RULE = :ecol_rule
    OPERATIONS = [:ecol_va_txn, :ecol_va_transfer, :ecol_va_earmark]
  end
end