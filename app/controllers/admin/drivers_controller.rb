class Admin::DriversController < Admin::AdminController
  before_action :set_driver, only: %i[ show edit update destroy ]

  def index
    @drivers = Driver.order(:name)
  end

  def show
  end

  def new
    @driver = Driver.new
  end

  def edit
  end

  def create
    @driver = Driver.new(driver_params)

    if current_user.editor? || current_user.administrator?
      respond_to do |format|
        if @driver.save
          format.html { redirect_to admin_drivers_url, notice: "Driver was successfully created." }
          format.json { render :show, status: :created, location: @driver }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @driver.errors, status: :unprocessable_entity }
        end
      end
    else
      render :new, status: :unauthorized
    end
  end

  def update
    if current_user.editor? || current_user.administrator?
      respond_to do |format|
        if @driver.update(driver_params)
          format.html { redirect_to admin_drivers_url, notice: "Driver was successfully updated." }
          format.json { render :show, status: :ok, location: @driver }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @driver.errors, status: :unprocessable_entity }
        end
      end
    else
      render :show, status: :unauthorized
    end
  end

  def destroy
    if current_user.editor? || current_user.administrator?
      @driver.destroy
      respond_to do |format|
        format.html { redirect_to admin_drivers_url, notice: "Driver was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      render :show, status: :unauthorized
    end
  end

  private
    def set_driver
      @driver = Driver.find(params[:id])
    end

    def driver_params
      params.require(:driver).permit(:name, :email, :phone, :zone_id, :is_leader)
    end
end
