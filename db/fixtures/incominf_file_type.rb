ScService.seed(:code) do |s|
  s.code = 'ECOL'
  s.name = 'Ecollect'
end

IncomingFileType.seed(:sc_service_id, :code) do |s|
  s.sc_service_id = ScService.find_by(code: 'ECOL').id
  s.code = 'RMTRS'
  s.name = 'Remitters File Upload'
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
  s.complete_with_failed_records = 'Y'
  s.apprv_before_process_records = 'N'
end