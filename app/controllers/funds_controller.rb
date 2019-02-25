class FundsController < ApplicationController
  before_action :user_is_admin!
  before_action :set_fund, only: [:edit, :update, :show, :destroy]

  def index
    @all = params[:all]
    @funds = current_organization.funds.includes(:holder, :category).order('users.surname, users.name, funds.name desc')
    @funds = @funds.where(available: true) unless @all
    @holders = @funds.inject({}) {|res, fund| res[fund.holder] ||= []; res[fund.holder] << fund; res}
  end

  def new
    @fund = current_organization.funds.new(available: 1)
  end

  def create
    @fund = current_organization.funds.new(fund_params)
    if @fund.save
      redirect_to funds_path, notice: "Il fondo è stato creato correttamente."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @fund.update_attributes(fund_params)
      redirect_to funds_path, notice: "Il fondo è stato aggiornato correttamente."
    else
      render action: 'edit'
    end
  end

  def show
    @repayments = @fund.repayments.includes(:holder)
    render layout: false if modal_page
  end

  def destroy
    if @fund.repayments.any?
      redirect_to @fund, alert: "Ci sono compensi registrati su questo fondo. Non è possibile cancellarlo."
    else
      @fund.destroy
      redirect_to funds_path
    end
  end

  # old jsons
  # def owners
  #   respond_to do |format|
  #     format.json { render json: Fund.holders2.to_json }
  #   end
  # end
  #
  # def justifications
  #   @fund = Fund.find(params[:id])
  #   respond_to do |format|
  #     format.json { render json: @fund.category.justifications.load }
  #   end
  # end

  private

  def set_fund
    @fund = Fund.find(params[:id])
  end

  def fund_params
    params.require(:fund).permit!
  end

end
