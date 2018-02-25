class AddTemplateColumnsToEcolCustomers < ActiveRecord::Migration
  def change
    add_column :ecol_customers, :rmtr_pass_template_id, :integer, comment: 'the id of the template to be used for sending alert to the remitters of this customer on credit pass'
    add_column :ecol_customers, :rmtr_return_template_id, :integer, comment: 'the id of the template to be used for sending alert to the remitters of this customer on credit return'
  end
end
