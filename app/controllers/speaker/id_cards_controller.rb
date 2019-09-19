class Speaker::IdCardsController < ApplicationController
  skip_before_action :redirect_unsigned_user
  before_action :get_repayment_from_token

  def create
    if params[:id_card]
      id_card = @repayment.id_cards.new(id_card_params)
      authorize [:speaker, id_card]
      id_card.description = "Id Document"
      if id_card.save
        flash[:notice] = "L'allegato è stato salvato."
      else
        flash[:error] = "Non è stato possibile salvere l'allegato. #{id_card.errors.first.inspect}."
      end
    end

    redirect_to edit_speaker_repayment_path(@repayment.spkr_token)
  end

  def destroy
    id_card = @repayment.id_cards.find(params[:id])
    authorize [:speaker, id_card]
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

