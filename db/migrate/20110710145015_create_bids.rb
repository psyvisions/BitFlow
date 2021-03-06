class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.integer :price
      t.float :amount
      t.string :currency
      t.string :status, :null => false
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :bids
  end
end
