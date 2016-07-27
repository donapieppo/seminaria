class DocumentsController < ApplicationController

  def new
    @seminar = Seminar.find(params[:seminar_id])
  end

  def create
    seminar  = Seminar.find(params[:seminar_id])
    user_owns!(seminar)
    document = seminar.documents.new(document_params)
    document.user_id = current_user.id

    logger.info document.inspect

    if document.save
      flash[:notice] = "L'allegato e' stato salvato"
    else
      flash[:error] = "Non e' stato possibile salvere l'allegato. #{document.errors.first.inspect}"
    end

    redirect_to edit_seminar_path(seminar)
  end

  def destroy
    document = Document.find(params[:id])
    if user_admin? or document.user_id == current_user.id
      document.destroy
    end
    redirect_to document.seminar_id ? edit_seminar_path(document.seminar_id) : repayment_path(document.repayment_id)
  end

  private 

  def document_params
    params[:document].permit(:description, :attach)
  end
end

