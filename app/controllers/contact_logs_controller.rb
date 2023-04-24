class ContactLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = current_user.contactLogs.all
  end
end
