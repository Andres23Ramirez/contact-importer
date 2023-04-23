class CreateImportedFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :imported_files do |t|
      t.string :name
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
