class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :file
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end

    add_index :images, [:user_id, :company_id]
  end
end
