# :spkr_token
class Speaker::RepaymentsController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:accept, :show, :edit, :update]
  before_action :get_repayment_from_token_and_authorize, only: [:accept, :show, :edit, :update]

  def data_request
    @repayment = Repayment.find(params[:id])
    authorize [:speaker, @repayment]
  end

  def submit_data_request
    @repayment = Repayment.find(params[:id])
    authorize [:speaker, @repayment]
  end

  def accept
    if @repayment.notified
      redirect_to(root_path, alert: "Too late to modify data. Please contact the organizer of the seminar.") and return
    end
  end

  def show
    if @repayment.notified
      redirect_to(root_path, alert: "Too late to modify data. Please contact the organizer of the seminar.") and return
    end
  end

  def edit
    if @repayment.notified
      redirect_to(root_path, alert: "Too late to modify data. Please contact the organizer of the seminar.") and return
    end
  end

  def update
    if @repayment.notified
      redirect_to(root_path, alert: "Too late to modify data. Please contact the organizer of the seminar.") and return
    elsif @repayment.update(speaker_repayment_attributes)
      redirect_to edit_speaker_repayment_path(@repayment.spkr_token), notice: "The data have been saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def get_repayment_from_token_and_authorize
    @repayment = Repayment.get_form_token(params[:id]) or raise "Uncorrect tkn."
    authorize [:speaker, @repayment]
  end

  def speaker_repayment_attributes
    params[:repayment].permit(
      :name, :surname, :email, :birth_date, :birth_place, :birth_country, :taxid,
      :italy, :address, :postalcode, :city, :country,
      :affiliation, :position_id,
      :iban, :swift, :aba, :bank_name, :bank_address
    )
  end
end
