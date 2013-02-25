class ChangeLimitOnInvitationCode < ActiveRecord::Migration
  def up
    change_column :invitations, :code, :string, :limit => 20
  end

  def down
    change_column :invitations, :code, :string, :limit => 40
  end
end
