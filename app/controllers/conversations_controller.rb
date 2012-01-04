class ConversationsController < ApplicationController
  before_filter :require_user
  before_filter :find_converation, :only => [:show, :update]
  
  # GET /conversations.json
  def index
    @conversations = Conversation.for_user(current_user).latest.all
    render json: @conversations
  end

  # GET /conversations/1.json
  def show
    render json: @conversation
  end
  
  # PUT /conversation/1.json
  def update
    # Can only update read attribute
    @conversation.read = params[:conversation][:read] if params[:conversation]

    if @conversation.save
      head :no_content
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end
  
  protected
    
    def find_converation
      @conversation = Conversation.for_user(current_user).find(params[:id])
    end
end