class DonationsController < ApplicationController
  before_action :set_donation, only: %i[ show edit update destroy ]

  # GET /donations or /donations.json
  def index
    @donations = Donation.all
  end

  # GET /donations/1 or /donations/1.json
  def show
  end

  # GET /donations/new
  def new
  end

  # GET /donations/1/edit
  def edit
  end

  # POST /donations or /donations.json
  def create
    @donation = donation_params
    # respond_to do |format|
    #   if @donation.save
    #     format.html { redirect_to donation_url(@donation), notice: "Donation was successfully created." }
    #     format.json { render :show, status: :created, location: @donation }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @donation.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /donations/1 or /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to donation_url(@donation), notice: "Donation was successfully updated." }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donations/1 or /donations/1.json
  def destroy
    @donation.destroy

    respond_to do |format|
      format.html { redirect_to donations_url, notice: "Donation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def donation_params
      params.require(:donation).permit(:amount)
    end
end
