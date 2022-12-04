class Admin::MessagesController < Admin::AdminController
  def index
    @numbers = Message.distinct.pluck(:number).uniq
    @number = params[:number]
    @message = Message.new(number: @number)
    @messages = Message.where(number: @number)
    @messages.update_all(viewed: true) if @messages.any?
    @new_message = Message.new
  end

  def show

  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to admin_messages_path(number: @message.number)
    else
      redirect_to admin_messages_path(number: @message.number)
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :number)
  end
end
