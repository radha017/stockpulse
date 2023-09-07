class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.string :transaction_type
      t.integer :quantity
      t.decimal :price
      t.datetime :timestamp

      t.timestamps
    end
  end
end
