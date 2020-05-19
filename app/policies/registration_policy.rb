class RegistrationPolicy < ApplicationPolicy

  def show?
    @user.id == @record.user_id
  end

  def create?
    true
  end

  def new_confirmation?
    true
  end

  def confirmation?
    true
  end
end

