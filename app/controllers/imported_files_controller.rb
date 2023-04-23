class ImportedFilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @imported_files = current_user.imported_file.all
  end

  def new
    @imported_file = ImportedFile.new
  end

  def create
    @imported_file = ImportedFile.new(name: imported_file_params[:file].original_filename, user: current_user)

    file = imported_file_params[:file]

    if @imported_file.save!
      file_path = Rails.root.join('tmp', file.original_filename)
      File.open(file_path, 'wb') do |f|
        f.write(file.read)
      end

      ContactImportJob.perform_later(@imported_file.id, file_path.to_s, getArrayColumns(), current_user, imported_file_params[:headers])

      flash[:success] = "The file has been successfully uploaded."
      redirect_to root_path
    else
      flash[:error] = "An error occurred while uploading the file."
      render :new
    end
  end

  private

  def imported_file_params
    params.permit(:file, :authenticity_token, :column_1, :column_2, :column_3, :column_4, :column_5, :column_6, :column_7, :headers )
  end

  def getArrayColumns
    [imported_file_params[:column_1], imported_file_params[:column_2], imported_file_params[:column_3], 
    imported_file_params[:column_4], imported_file_params[:column_5], imported_file_params[:column_6], 
    imported_file_params[:column_7]]
  end
  
end
