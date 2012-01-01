class MessagesController < ApplicationController
  # GET /messages.json
  def index
    @messages = Message.all
    render json: @messages
  end

  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])
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

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(params[:message])
      head :no_content
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    head :no_content
  end
end
