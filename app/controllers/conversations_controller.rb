class ConversationsController < ApplicationController
  before_filter :require_user
  before_filter :find_converation, :only => [:show, :update]
  
  # GET /conversations.json
  def index
    @conversations = Conversation.for_user(current_user).latest
    @conversations = @conversations.paginate(:page => params[:page], :per_page => 30)
    @conversations = @conversations.all(:include => [:user, :to_users, {:messages => :from_user}])
    render json: @conversations
  end
  
  def activity
    @conversations = Conversation.for_user(current_user).activity
    @conversations = @conversations.paginate(:page => params[:page], :per_page => 30)
    @conversations = @conversations.all(:include => [:user, :to_users, {:messages => :from_user}])
    render json: @conversations
  end
  
  def starred
    @conversations = Conversation.for_user(current_user).starred
    @conversations = @conversations.paginate(:page => params[:page], :per_page => 30)
    @conversations = @conversations.all(:include => [:user, :to_users, {:messages => :from_user}])
    render json: @conversations
  end

  # GET /conversations/1.json
  def show
    respond_to do |format|
      format.html { render :layout => "basic" }
      format.json { render json: @conversation }
    end
  end
  
  # PUT /conversation/1.json
  def update
    if @conversation.update_attributes(params[:conversation])
      head :no_content
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end
  
  # GET /conversation/between.json?to=@maccman,info@eribium.org
  def between
    @conversations = Conversation.between(current_user, *User.for(params[:to]))
    render json: @conversations
  end
  
  protected
    
    def find_converation
      @conversation = Conversation.for_user(current_user).find(params[:id])
    end
end