class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    message.save
    redirect_to room_path(message.room_id)
  end

private
  
  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end
  
end