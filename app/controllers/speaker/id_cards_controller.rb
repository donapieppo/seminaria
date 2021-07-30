class Speaker::IdCardsController < ApplicationController
  skip_before_action :redirect_unsigned_user
  before_action :get_repayment_from_token

  def create
    authorize [:speaker, :id_card]
    if params[:id_card]
      id_card = @repayment.id_cards.new(id_card_params)
      id_card.description = "Id Document"
      if id_card.save
        flash[:notice] = "The attachemnt has been saved."
      else
        flash[:error] = "It was not possible to save the attachment. #{id_card.errors.first.inspect}."
      end
    end

    redirect_to edit_speaker_repayment_path(@repayment.spkr_token)
  end

  def destroy
    id_card = @repayment.id_cards.find(params[:id])
    authorize [:speaker, :id_card]
    id_card.destroy
    redirect_to edit_speaker_repayment_path(@repayment.spkr_token)
  end

  private 

  def get_repayment_from_token
    @repayment = Repayment.where(spkr_token: params[:repayment_id]).first or raise "Uncorrect tkn."
  end

  def id_card_params
    params[:id_card].permit(:attach)
  end
end

