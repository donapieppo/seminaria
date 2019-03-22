class DocumentsController < ApplicationController
  before_action :get_seminar_and_check_permission

  def create
    document = @seminar.documents.new(document_params)
    document.user_id = current_user.id

    authorize(document)

    logger.info document.inspect

    if document.save
      flash[:notice] = "L'allegato è stato salvato."
    else
      flash[:error] = "Non è stato possibile salvere l'allegato. #{document.errors.first.inspect}."
    end

    redirect_to edit_seminar_path(@seminar)
  end

  def destroy
    document = @seminar.documents.find(params[:id])
    authorize(document)
    document.destroy
    redirect_to document.seminar_id ? edit_seminar_path(document.seminar_id) : repayment_path(document.repayment_id)
  end

  private 

  def get_seminar_and_check_permission
    @seminar = Seminar.find(params[:seminar_id])
  end

  def document_params
    params[:document].permit(:description, :attach)
  end
end

