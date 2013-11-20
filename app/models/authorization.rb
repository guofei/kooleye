class Authorization < ActiveRecord::Base
  belongs_to :user

  before_create :check_facebook_token

  def check_facebook_token
    if(provider == 'facebook')
      begin
        @graph = Koala::Facebook::API.new(self.token)
        self.token = nil if not @graph.debug_token(self.token)["data"]["scopes"].include? "publish_stream"
      rescue
        self.token = nil
      end
    end
  end
end
