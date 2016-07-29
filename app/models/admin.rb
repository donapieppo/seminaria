class Admin < ActiveRecord::Base
  extend DmUniboCommon::UserUpnMethods::ClassMethods

  belongs_to_dsa_user :user # see dm_unibo_common/lib/dm_unibo_common/user_upn_methods.rb
  belongs_to :organization

  validates :organization_id, uniqueness: {scope: :user_id}

  def to_s
    self.user
  end
end

