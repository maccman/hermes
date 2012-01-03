class ConversationsController < ApplicationController
  before_filter :require_user
  
  # GET /conversations.json
  def index
    @conversations = Conversation.for_user(current_user).latest.all
    render json: @conversations
  end

  # GET /conversations/1.json
  def show
    @conversation = Conversation.for_user(current_user).find(params[:id])
    render json: @conversation
  end
end