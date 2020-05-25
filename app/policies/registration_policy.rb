class RegistrationPolicy < ApplicationPolicy

  # policy @seminar
  # def index?
  # end

  def create?
    true
  end

  def destroy?
    @record.user_id == @user.id
  end
end

