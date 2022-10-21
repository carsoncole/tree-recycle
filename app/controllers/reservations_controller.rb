class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit form_1 form_2 update destroy ]
  before_action :require_login, only: %i[ index destroy ]

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    render 'form_1'
  end

  # GET /reservations/1/edit
  def edit
  end

  def form_1
  end


  def form_2
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservation_form_2_url(@reservation), notice: "Reservation was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street_1, :street_2, :city, :state, :zip, :country, :latitude, :longitude)
    end
end
