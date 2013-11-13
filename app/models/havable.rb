class Havable < ActiveRecord::Base
  belongs_to :user
  belongs_to :thing

  def duplication?
    not self.class.where(user_id: user_id, thing_id: thing_id).empty?
  end
end
