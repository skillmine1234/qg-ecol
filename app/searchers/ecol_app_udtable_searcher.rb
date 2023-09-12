class EcolAppUdtableSearcher
  include ActiveModel::Validations
  attr_accessor :page, :app_code, :approval_status
  PER_PAGE = 10
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def paginate
    if valid? 
      find.paginate(per_page: PER_PAGE, page: page)
    else
      EcolAppUdtable.none.paginate(per_page: PER_PAGE, page: page)
    end
  end

  private  
  def persisted?
    false
  end

  def find
    reln = approval_status == 'U' ? EcolAppUdtable.unscoped.where("approval_status =?",'U').order("id desc") : EcolAppUdtable.order("id desc")
    reln = reln.where("app_code=?", app_code) if app_code.present?
    reln
  end
end