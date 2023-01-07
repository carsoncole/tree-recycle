class Admin::MessagesController < Admin::AdminController
  def index
    @numbers = Message.distinct.pluck(:number).uniq
    @number = params[:number]
    @message = Message.new(number: @number)
    @messages = Message.where(number: @number).order(:created_at)
    @messages.update_all(viewed: true) if @messages.any?
    @new_message = Message.new
  end

  def create
    if current_user.administrator? || current_user.editor?
      @message = Message.new(message_params)
      if @message.outgoing? && @message.body.include?('special:drivers')
        body = 'ALL DRIVERS: '
        body += @message.body.gsub(' special:drivers','')
        Driver.all.map{|d| d.phone}.uniq.each do |driver|
          next unless driver.phone.present?
          Message.create(direction: 'outgoing', body: body, number: driver.phone)
        end
        redirect_to admin_messages_path(number: @message.number)
      elsif @message.save
        redirect_to admin_messages_path(number: @message.number)
      else
        redirect_to admin_messages_path(number: @message.number)
      end
    else
      redirect_to admin_messages_path, status: :unauthorized
    end
  end

  def destroy
    if current_user.administrator? || current_user.editor?
      message = Message.find(params[:id])
      Message.where(number: message.number).destroy_all
      redirect_to admin_messages_path
    else
      redirect_to admin_messages_path, status: :unauthorized
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :number)
  end
end
