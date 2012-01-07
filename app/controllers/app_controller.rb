class AppController < ApplicationController
  before_filter :require_user
  
  def index
    @config_json = ({juggernaut: Rails.config.juggernaut}).to_json
    @user_json   = current_user.to_json(methods: :autocomplete)
  end
end
