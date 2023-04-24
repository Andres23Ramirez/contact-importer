class Contact < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :date_of_birth, :phone, :address, :credit_card_number, :credit_card_network, :email

  validates_format_of :name, without: /[^a-zA-Z0-9 -]/, message: "must contain only letters, numbers, spaces and hyphens"

  validate :valid_date_format

  validates :phone, format: { with: /\A\(\+\d{2}\) (\d{3}[- ]\d{3} \d{2} \d{2})\z/, message: "must be in format (+00) 000 000 00 00 or (+00) 000-000-00-00" }

  validates :credit_card_number, length: { 
    is: 15, message: "must have 15 digits" 
  }, if: Proc.new { |c| c.get_credit_card_network == "American Express" }
  
  validates :credit_card_number, length: { 
    is: 16, message: "must have 16 digits" 
  }, if: Proc.new { |c| ["Diners Club International", "Diners Club United States & Canada", "Discover", "JCB", "Maestro", "Mastercard", "Visa", "Visa Electron"].include?(c.get_credit_card_network) }
  
  validates :credit_card_number, length: { 
    minimum: 16, maximum: 19, message: "must have between 16 and 19 digits" 
  }, if: Proc.new { |c| ["China UnionPay"].include?(c.get_credit_card_network) }

  validates :email, presence: true, uniqueness: { scope: :user_id }, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :set_credit_card_network
  after_validation :encrypt_credit_card_number

  def formatted_date_of_birth
    date = Date.parse(date_of_birth)
    date.strftime('%Y %B %-d')
  end

  def masked_credit_card_number(value)
    decrypted_value = decrypt(value)
    if decrypted_value
      decrypted_value.gsub(/.(?=.{4})/, '*')
    else
      nil
    end
  end

  def get_credit_card_network
    # Visa Electron
    if credit_card_number =~ /^4(026|17500|405|508|844|91[37])/ && [16, 19].include?(credit_card_number.length)
      return "visa-electron"
    end
    
    # Visa
    if credit_card_number =~ /^4/ && [13, 16, 19].include?(credit_card_number.length)
      return "visa"
    end

    puts "credit_card_number: #{credit_card_number}"
    puts "credit_card_number: #{credit_card_number.class}"
    puts "if: #{credit_card_number =~ /^4/}"
    puts "length: #{credit_card_number.length}"
    
    # Mastercard
    if credit_card_number =~ /^5[1-5]/ && credit_card_number.length == 16
      return "mastercard"
    end
    
    # American Express
    if credit_card_number =~ /^3[47]/ && credit_card_number.length == 15
      return "american-express"
    end
    
    # Discover
    if credit_card_number =~ /^6(?:011|5)/ && credit_card_number.length == 16
      return "discover"
    end
    
    # JCB
    if credit_card_number =~ /^35(?:2[89]|[3-8][0-9])/ && credit_card_number.length == 16
      return "jcb"
    end
    
    # Diners Club
    if credit_card_number =~ /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/ && credit_card_number.length == 14
      return "diners-club"
    end
    
    # Unknown
    return credit_card_network
  end
  

  private

  def valid_date_format
    # Check if date_of_birth is present and matches the desired formats
    if date_of_birth.present? && !date_of_birth.to_s.match(/\A\d{4}\d{2}\d{2}\z|\A\d{4}-\d{2}-\d{2}\z/)
      errors.add(:date_of_birth, "must be in the format YYYYMMDD or YYYY-MM-DD")
    end
  end

  def encrypt_credit_card_number
    if self.errors[:credit_card_number].empty?
      self.credit_card_number = encrypt(self.credit_card_number)
    end
  end

  def decrypt_credit_card_number
    # Decrypt the credit card number if it has been encrypted
    if self.credit_card_number.present?
      decrypt(self.credit_card_number)
    end
  end

  def encrypt(value)
    key = ENV['CREDIT_CARD_ENCRYPTION_KEY']
    key = OpenSSL::Digest::SHA256.digest(key)[0..31]
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = key
    iv = cipher.random_iv
    encrypted_value = cipher.update(value) + cipher.final
    encoded_encrypted_value = Base64.encode64(encrypted_value).chomp
    encoded_iv = Base64.encode64(iv).chomp
    "#{encoded_encrypted_value}$#{encoded_iv}"
  end

  def decrypt(value)
    key = ENV['CREDIT_CARD_ENCRYPTION_KEY']
    key = OpenSSL::Digest::SHA256.digest(key)[0..31]
    encoded_encrypted_number, encoded_iv = value.split('$')
    encrypted_number = Base64.decode64(encoded_encrypted_number)
    iv = Base64.decode64(encoded_iv)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
    decrypted_number = decipher.update(encrypted_number) + decipher.final
    decrypted_number
  end

  def set_credit_card_network
    self.credit_card_network = get_credit_card_network
  end
end
