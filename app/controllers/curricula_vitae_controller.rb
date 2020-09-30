class CurriculaVitaeController < ApplicationController

  def destroy
    @repayment = Repayment.find(params[:repayment_id])
    cv = @repayment.curricula_vitae.find(params[:id])
    authorize cv
    cv.destroy
    redirect_to @repayment
  end

end
