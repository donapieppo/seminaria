class CurriculaVitaeController < ApplicationController
  before_action :get_repayment_and_seminar_and_check_permission

  def destroy
   cv = @repayment.curricula_vitae.find(params[:id])
   authorize cv
   cv.destroy
   redirect_to @repayment
  end

  private

  def get_repayment_and_seminar_and_check_permission
    @repayment = Repayment.find(params[:repayment_id])
  end
end
