class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :thing

  def duplication?
    not self.class.where(user_id: user_id, thing_id: thing_id, vote_type: vote_type).empty?
  end
end
