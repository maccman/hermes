class ConversationsController < ApplicationController
  before_filter :require_user, :except => :show
  before_filter :find_converation, :only => [:show, :update]
  
  # GET /conversations.json
  def index
    @conversations = Conversation.for_user(current_user).latest.all
    render json: @conversations
  end

  # GET /conversations/1.json
  def show
    if logged_in?
      find_converation
    elsif token = params[:access_token]
      @conversation = Conversation.for_token(token).find(params[:id])
    end
    
    respond_to do |format|
      format.html { render :layout => "basic" }
      format.json { render json: @conversation }
    end
  end
  
  # PUT /conversation/1.json
  def update
    # Can only update read attribute
    @conversation.read = params[:read] if params.has_key?(:read)

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