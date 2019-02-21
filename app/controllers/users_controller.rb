class UsersController < ApplicationController
  def new
  end

  def create
    if r = /\A(\w+\.\w+)(@unibo.it)?\z/.match(params[:upn])
      upn = r[1] + '@unibo.it'
      begin
        User.syncronize(upn)
      rescue DmUniboCommon::NoUser
        flash[:alert] = "Non esiste l'utente selezionato nel database di Ateneo."
      end
    end
    redirect_to new_user_path
  end
end
