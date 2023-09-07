class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.json :data

      t.timestamps
    end
  end
end
