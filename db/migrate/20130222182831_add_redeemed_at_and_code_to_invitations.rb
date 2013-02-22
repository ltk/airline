class AddRedeemedAtAndCodeToInvitations < ActiveRecord::Migration
  def change
    change_table :invitations do |t|
      t.string :code, :limit => 40
      t.datetime :redeemed_at
      t.index [:code]
    end
  end
end
