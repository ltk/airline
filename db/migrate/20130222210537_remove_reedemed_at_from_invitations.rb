class RemoveReedemedAtFromInvitations < ActiveRecord::Migration
  def change
    remove_column :invitations, :redeemed_at
  end
end
