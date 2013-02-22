class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.column :company_id, :integer

      t.timestamps
    end
  end
end
