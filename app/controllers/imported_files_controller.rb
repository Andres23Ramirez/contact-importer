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

    if @imported_file.save!
      # Procesar el archivo CSV
      flash[:success] = "The file has been successfully uploaded."
      redirect_to root_path
    else
      flash[:error] = "An error occurred while uploading the file."
      render :new
    end
  end

  private

  def imported_file_params
    params.permit(:file, :authenticity_token, :column_1, :column_2, :column_3, :column_4, :column_5, :column_6, :column_7 )
  end
end
