class EcolVaEarmarkDecorator < EcolOperationDecorator
  def hold_no
    h.link_to object.hold_no, h.ecol_va_earmark_path(object)
  end  
end