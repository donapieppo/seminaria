class DocumentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    @user and SeminarPolicy.new(@user, @record.seminar).update?
  end

  def destroy?
    create?
  end
end
