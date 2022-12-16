class User < ApplicationRecord
  include Clearance::User

  enum :role, { viewer: 0, editor: 1, administrator: 2 }, default: :viewer

  def role_rank
    User.roles[self.role]
  end
end
