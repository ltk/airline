class AddBayeuxTokenToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :bayeux_token, :string, :limit => 40
  end
end
