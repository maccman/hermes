class MessagesController < ApplicationController
  before_filter :require_user
  before_filter :find_message, :only => [:show, :update, :destroy]
  
  # GET /messages.json
  def index
    @messages = Message.for_user(current_user).latest_last
    @messages = @messages.paginate(:page => params[:page], :per_page => 30)
    @messages = @messages.all(:include => [:from_user, :to_users])
    render json: @messages
  end

  # GET /messages/1.json
  def show
    render json: @message
  end

  # GET /messages/new.json
  def new
    @message = Message.new
    render json: @message
  end

  # POST /messages.json
  def create
    @message           = Message.new(params[:message])
    @message.user      = current_user
    @message.from_user = current_user
    
    if params[:conversation_id]
      @message.conversation = Conversation.for_user(current_user).find(params[:conversation_id])
    end

    if @message.save
      @message.siblings.each do |message|
        publish(:create, message)
        publish(:create, message.conversation)
      end
      
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PUT /messages/1.json
  def update
    # Can only update starred attribute
    if @message.update_attributes(params[:message])
      publish(:update, @message)
      publish(:update, @message.conversation)
      head :no_content
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1.json
  def destroy
    @message.destroy
    head :no_content
  end
    
  protected
    def find_message
      @message = Message.for_user(current_user).find(params[:id])
    end
end
