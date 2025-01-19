class CreateBills < ActiveRecord::Migration[8.0]
  def change
    create_table :bills do |t|
      t.references :debt, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.string :external_id
      t.text :error_message
      t.datetime :generated_at
      t.datetime :sent_at

      t.timestamps
    end

    add_index :bills, :status
    add_index :bills, :external_id
  end
end
