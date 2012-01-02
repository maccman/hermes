class ConversationsController < ApplicationController
  before_filter :require_user
  
  # GET /conversations.json
  def index
    @conversations = Conversation.for_user(current_user).all
    render json: @conversations
  end

  # GET /conversations/1.json
  def show
    @conversation = Conversation.for_user(current_user).find(params[:id])
    render json: @conversation
  end

  # GET /conversations/new.json
  def new
    @conversation = Conversation.new
    render json: @conversation
  end

  # POST /conversations.json
  def create
    @conversation = Conversation.new(params[:conversation])
    @conversation.from = current_user

    if @conversation.save
      render json: @conversation, status: :created, location: @conversation
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /conversations/1.json
  def destroy
    @conversation = Conversation.for_user(current_user).find(params[:id])
    @conversation.destroy
    head :no_content
  end
end