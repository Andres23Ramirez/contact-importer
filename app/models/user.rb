class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :imported_file

  def email
    self.username
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
