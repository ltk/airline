class RemoveCompanyNameAndAddCompanyIdForUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :company_name
    end
  end
end
