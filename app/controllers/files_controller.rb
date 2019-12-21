class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_file, only: %i[destroy]

  authorize_resource

  def destroy
    @record = @file.record
    return head :forbidden unless current_user&.owns?(@record)

    @file.purge
    @record.reload

    # render "destroy_from_#{@record.class.to_s.downcase}.js.erb"
  end

  private

  def set_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
