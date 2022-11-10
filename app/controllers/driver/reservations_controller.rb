class Driver::ReservationsController < Driver::DriverController
  def search
  end

  def map
    @zone = Zone.find(params[:zone_id])
  end
end
