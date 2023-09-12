module EcolAppUdtableHelper
  def get_humanized_label(udf)
    udf.humanize unless udf.nil?
  end
end