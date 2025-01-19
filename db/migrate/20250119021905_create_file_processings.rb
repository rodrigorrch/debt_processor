class CreateFileProcessings < ActiveRecord::Migration[8.0]
  def change
    create_table :file_processings do |t|
      t.string :filename, null: false
      t.integer :status, default: 0, null: false
      t.string :file_blob_id
      t.text :error_message
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :file_processings, :status
    add_index :file_processings, :filename
  end
end
