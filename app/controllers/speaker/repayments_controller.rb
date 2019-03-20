# :spkr_token
class Speaker::RepaymentsController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:edit, :update, :end_data_request]
  before_action :get_repayment_from_token, only: [:show, :edit, :update, :end_data_request]

  def data_request
    @repayment = Repayment.find(params[:id])
    authorize @repayment
  end

  def submit_data_request
    @repayment = Repayment.find(params[:id])
    authorize @repayment
  end

  def show
  end

  def edit
  end

  def update
    if @repayment.update_attributes(speaker_repayment_attributes) 
      add_id_card
      redirect_to edit_speaker_repayment_path(@repayment.spkr_token), notice: 'The data have been saved.'
    else
      render :edit
    end
  end

  private

  def get_repayment_from_token
    @repayment = Repayment.where(spkr_token: params[:id]).first or raise "NO"
  end

  def speaker_repayment_attributes
    params[:repayment].permit(:name, :surname, :email, :birth_date, :birth_place, :birth_country, :taxid, 
                              :italy, :address, :postalcode, :city, :country, 
                              :affiliation, :position_id, 
                              :iban, :swift, :aba)
  end

  def add_id_card
    if params[:repayment][:id_card]
      document = @repayment.id_cards.create!(attach: params[:repayment][:id_card], description: "Id Card")
      logger.info document.inspect
    end
  end

end

