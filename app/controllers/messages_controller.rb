class MessagesController < ApplicationController
  # GET /messages.json
  def index
    @messages = Message.for_user(current_user).latest.all
    render json: @messages
  end

  # GET /messages/1.json
  def show
    @message = Message.for_user(current_user).find(params[:id])
    render json: @message
  end

  # GET /messages/new.json
  def new
    @message = Message.new
    render json: @message
  end

  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @message.user = current_user
    @message.from_user = current_user
    
    if params[:conversation_id]
      @message.conversation = Conversation.for_user(current_user).find(params[:conversation_id])
    end

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PUT /messages/1.json
  def update
    @message = Message.for_user(current_user).find(params[:id])

    # Can only update starred attribute
    @message.starred = params[:message][:starred] if params[:message]

    if @message.save
      head :no_content
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1.json
  def destroy
    @message = Message.for_user(current_user).find(params[:id])
    @message.destroy
    head :no_content
  end
end
