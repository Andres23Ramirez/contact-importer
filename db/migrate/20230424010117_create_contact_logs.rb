class CreateContactLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_logs do |t|
      t.string :name
      t.string :date_of_birth
      t.string :phone
      t.string :address
      t.string :credit_card_number
      t.string :credit_card_network
      t.string :email
      t.string :file_imported_name
      t.text :error
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
