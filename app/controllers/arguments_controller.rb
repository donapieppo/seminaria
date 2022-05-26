class ArgumentsController < ApplicationController
  before_action :get_argument_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @arguments = current_organization.arguments.order(:name)
    authorize Argument
  end

  def show
    @argument = Argument.find(params[:id])
    @seminars = @argument.seminars.this_year.order('date desc').includes(:organization)
    authorize @argument
  end

  def new
    @argument = current_organization.arguments.new
    authorize @argument
  end

  def create
    @argument = current_organization.arguments.new(name: params[:argument][:name])
    authorize @argument
    if @argument.save
      redirect_to arguments_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @argument.update(name: params[:argument][:name])
      redirect_to arguments_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def get_argument_and_check_permission
    @argument = Argument.find(params[:id])
    authorize @argument
  end
end
