class Admin::MessagesController < Admin::AdminController
  def index
    @phone_numbers = Message.order(created_at: :desc).pluck(:phone).uniq
    @phone = params[:phone]
    @message = Message.new(phone: @phone)
    @new_message = Message.new
  end

  def show
    @phone = params[:phone]
    @new_message = Message.new(phone: @phone)
    @messages = Message.order(created_at: :desc).where(phone: @phone)
    @reservations = Reservation.not_archived.where(phone: @phone)
    @messages.update_all(viewed: true) if @messages.any?
  end

  def create
    if current_user.administrator? || current_user.editor?
      @message = Message.new(message_params)
      if @message.outgoing? && @message.body.include?('special:drivers')
        body = 'ALL DRIVERS: '
        body += @message.body.gsub(' special:drivers','')
        Driver.all.map{|d| d.phone}.uniq.each do |phone|
          next if phone == '???'
          Message.create(direction: 'outgoing', body: body, phone: phone)
        end
        redirect_to admin_messages_path
      elsif @message.save
        redirect_to admin_phone_path(phone: @message.phone)
      else
        redirect_to admin_messages_path(phone: @message.phone)
      end
    else
      redirect_to admin_messages_path, status: :unauthorized
    end
  end

  def destroy
    if current_user.administrator? || current_user.editor?
      message = Message.find(params[:id])
      Message.where(phone: message.phone).destroy_all
      redirect_to admin_messages_path
    else
      redirect_to admin_messages_path, status: :unauthorized
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :phone)
  end
end
