IncomingFileType.seed(:sc_service_id, :code) do |s|
  s.sc_service_id = ScService.find_by(code: 'ECOL').id
  s.code = 'VACD'
  s.name = 'Ecol VirtualAccount Credit Debit'
  s.msg_domain = 'DFDL'
  s.msg_model = '{http://www.quantiguous.com/services/file}:ecolVaCreditDebit'
  s.skip_first = 'Y'
  s.auto_upload = 'N'
  s.validate_all = 'Y'
  s.build_response_file = 'Y'
  s.db_unit_name = 'pk_qg_ecol_vacd_file_manager'
  s.records_table = 'ecol_vacd_incoming_records'
  s.can_override = 'N'
  s.can_skip = 'N'
  s.can_retry = 'N'
  s.build_nack_file = 'Y'
  s.skip_last = 'N'
  s.finish_each_file = 'N'
  s.is_file_mapper = 'N'
end

IncomingFileType.seed(:sc_service_id, :code) do |s|
  s.sc_service_id = ScService.find_by(code: 'ECOL').id
  s.code = 'ECOL_RMTRS'
  s.name = 'Ecol Remitters'
  s.msg_domain = 'DFDL'
  s.msg_model = '{http://www.quantiguous.com/services/file}:ecolRemitter'
  s.skip_first = 'Y'
  s.auto_upload = 'N'
  s.validate_all = 'Y'
  s.build_response_file = 'N'
  s.db_unit_name = "pk_qg_ecol_file_manager"
  s.records_table = 'ecol_incoming_records'
  s.can_override = 'N'
  s.can_skip = 'Y'
  s.can_retry = 'N'
  s.build_nack_file = 'N'
  s.skip_last = 'N'
  s.finish_each_file = 'N'
  s.is_file_mapper = 'N'
end