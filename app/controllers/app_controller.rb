class AppController < ApplicationController
  before_filter :require_user
  
  def index
    @user_json = current_user.to_json(methods: :autocomplete)
  end
end
