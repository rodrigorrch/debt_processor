class CreateDebts < ActiveRecord::Migration[8.0]
  def change
    create_table :debts do |t|
      t.string :name, null: false
      t.string :government_id, null: false
      t.string :email, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :due_date, null: false
      t.string :debt_id, null: false
      t.references :file_processing, null: false, foreign_key: true

      t.timestamps
    end

    add_index :debts, :debt_id, unique: true
    add_index :debts, :government_id
    add_index :debts, :email
  end
end
