class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = current_user.contacts.all.page(params[:page]).per(10)
  end
end
