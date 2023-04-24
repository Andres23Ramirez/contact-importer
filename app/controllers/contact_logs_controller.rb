class ContactLogsController < ApplicationController
  def index
    @contacts = current_user.contactLogs.all
  end
end
