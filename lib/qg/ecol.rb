require "qg/ecol/engine"

module Qg
  module Ecol
    NAME = 'ECollect'
    GROUP = 'e-collect'
    MENU_ITEMS = [:ecol_app, :ecol_customer, :ecol_remitter, :ecol_transaction, :udf_attribute, :ecol_summary,:ecollect_request_template,:ecollect_response_template]
    MODELS = ['EcolRule','EcolCustomer','EcolRemitter','EcolTransaction','UdfAttribute','IncomingFile','EcolFetchStatistic',
              'OutgoingFile','EcolApp','EcolAppUdtable','EcolSummary','EcolVacdIncomingFile','EcolVacdIncomingRecord','IncomingFileRecord','EcolIncomingFile','EcolIncomingRecord','EcollectRequestTemplate','EcollectHashTemplate','EcollectRequestParameter','EcollectEncryptDecrypt','EcollectResponseTemplate']
    TEST_MENU_ITEMS = []
    COMMON_MENU_ITEMS = [:incoming_file]
    RULE = :ecol_rule
    OPERATIONS = []
  end
end