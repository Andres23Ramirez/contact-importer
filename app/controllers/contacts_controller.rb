class ContactsController < ApplicationController
  def index
    @contacts = current_user.contacts.all
  end
end
