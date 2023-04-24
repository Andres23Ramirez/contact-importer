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
    iin = credit_card_number.to_s[0..5]
    case iin
    when /^(34|37)/
      "American Express"
    when /^5610/
      "Bankcard"
    when /^31/
      "China T-Union"
    when /^62/
      "China UnionPay"
    when /^36/
      "Diners Club International"
    when /^54/
      "Diners Club United States & Canada"
    when /^(6011|65|644|645|646|647|648|649)/
      "Discover"
    when /^622/
      "China UnionPay"
    when /^604001/
      "UkrCard"
    when /^(60|81|82|508)/
      "RuPay"
    when /^636/
      "InterPayment"
    when /^637/
      "InstaPayment"
    when /^(352[8-9]|35[3-8][0-9])/
      "JCB"
    when /^(6304|670[69]|6771)/
      "Laser"
    when /^(5018|5020|5038|6304|6759|676[1-3])/
      "Maestro"
    when /^5019/
      "Dankort"
    when /^4571/
      "Visa"
    when /^(2200|2201|2202|2203|2204)/
      "Mir"
    when /^2205/
      "BORICA"
    when /^65/
      "Troy"
    when /^(222[1-9]|22[3-6][0-9]|227[0-2][0-9]|2273[0-5])/
      "Mastercard"
    when /^(51|52|53|54|55)/
      "Mastercard"
    when /^(6334|6767)/
      "Solo"
    when /^(4903|4905|4911|4936|6333|6759|564182|633110)/
      "Switch"
    when /^4/
      "Visa"
    when /^(4026|417500|4508|4844|491(3|7))/
      "Visa Electron"
    when /^1/
      "UATP"
    when /^(506099|5061[0-8][0-9]|650002|650003|650004|650005|650006|650007|650008|650009|5078[6-9][0-9]|507[9][0-9]{2}|60698[2-8])/
      "Verve"
    when /^357111/
      "LankaPay"
    when /^8600/
      "UzCard"
    when /^9860/
      "Humo"
    when /^([126789])/
      "GPN"
    when /^9704/
      "Napas"
    else
      "Unknown"
    end
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
    # Generate a salt
    salt = BCrypt::Engine.generate_salt

    # Hash the value with the salt
    hashed_value = BCrypt::Engine.hash_secret(value, salt)

    # Return the hashed value with the salt concatenated
    "#{hashed_value}$#{salt}"
  end

  def decrypt(value)
    hashed_value, salt = value.split('$')

    # Hash the value with the salt and compare it with the hashed value
    if BCrypt::Engine.hash_secret(BCrypt::Engine.hash_secret(value, salt), salt) == hashed_value
      return value
    else
      return nil
    end
  end

  def set_credit_card_network
    self.credit_card_network = get_credit_card_network
  end
end
