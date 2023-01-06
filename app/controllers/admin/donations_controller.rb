class Admin::DonationsController < Admin::AdminController
  def index
    if params[:no_reservation]
      @pagy, @donations = pagy(Donation.where(reservation_id: nil).order(id: :desc))
    else
      @pagy, @donations = pagy(Donation.order(id: :desc))
    end
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def edit
    @donation = Donation.find(params[:id])
  end

  def new
    @reservation = Reservation.find(params[:reservation_id]) if params[:reservation_id]
    @donation = Donation.new
    @donation.form = "cash_or_check"
  end

  def update
    if current_user.editor? || current_user.administrator?
      @donation = Donation.find(params[:id])
      if current_user.editor? || current_user.administrator?
        if @donation.update(donation_params)
          redirect_to admin_donation_url(@donation), notice: "Donation was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        redirect_to admin_donation_url(donation), alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
      end
    else
      render :show, status: :unauthorized
    end
  end

  def create
    if current_user.editor? || current_user.administrator?
      @donation = Donation.new(donation_params)
      @donation.payment_status = 'paid'

      if current_user.editor? || current_user.administrator?
        if @donation.save
          if @donation.reservation_id.present?
            redirect_to admin_reservation_url(@donation.reservation_id)
          else
            redirect_to admin_donations_path
          end
        else
          render :new, status: :unprocessable_entity
        end
      else
        redirect_to admin_donations_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
      end
    else
      render :show, status: :unauthorized
    end
  end

  def destroy
    if current_user.editor? || current_user.administrator?
      @donation = Donation.find(params[:id])
      @donation.destroy
      respond_to do |format|
        format.html { redirect_to admin_donations_url, notice: "Donation was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      render :show, status: :unauthorized
    end
  end

  def send_donation_receipt
    donation = Donation.find(params[:donation_id])
    donation.update(is_receipt_email_sent: false)
    donation.send_receipt_email!
    redirect_to admin_reservation_url(donation.reservation)
  end

  private

    def donation_params
      params.require(:donation).permit(:email, :amount, :form, :reservation_id)
    end
end
