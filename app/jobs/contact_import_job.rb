class ContactImportJob < ApplicationJob
  require 'csv'
  queue_as :default

  def perform(imported_file_id, file_path, columns, user, headers)
    imported_file = ImportedFile.find(imported_file_id)
    imported_file.status = 1
    imported_file.save

    failed = true

    CSV.foreach(file_path, headers: !!headers) do |row|
      contact = Contact.new(
        name: row[columns.index("Name")],
        date_of_birth: row[columns.index('Date of Birth')],
        phone: row[columns.index('Phone')],
        address: row[columns.index('Address')],
        credit_card_number: row[columns.index('Credit Card Number')],
        credit_card_network: row[columns.index('Credit Card Network')],
        email: row[columns.index('Email')], 
        user: user
      )
    
      if contact.save
        failed = false
        puts "Contact Save: #{contact.inspect}"
      else
        puts "Error saving contact: #{contact.errors.full_messages.join(", ")}"
        contactLog = ContactLog.new(
          name: row[columns.index("Name")],
          date_of_birth: row[columns.index('Date of Birth')],
          phone: row[columns.index('Phone')],
          address: row[columns.index('Address')],
          credit_card_number: row[columns.index('Credit Card Number')],
          credit_card_network: row[columns.index('Credit Card Network')],
          email: row[columns.index('Email')],
          error: contact.errors.full_messages.join(", "),
          user: user
        )
        contactLog.save
      end
    end

    imported_file.status = failed ? 2 : 3
    imported_file.save

    # delete the temporary file
    File.delete(file_path)
  end
end
