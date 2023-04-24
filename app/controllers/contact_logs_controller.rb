class ContactLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contactLogs = current_user.contactLogs.all.page(params[:page]).per(10)
  end
end
