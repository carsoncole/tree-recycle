class Driver::ZonesController < Driver::DriverController
  def index
    @zones = Zone.includes(:routes).order(:name)
    @pending_pickups_count = Reservation.pending_pickup.routed.count
    @missing_count = Reservation.missing.count
    @picked_up_count = Reservation.picked_up.count

    respond_to do |format|
      format.html
      format.pdf do 
        render pdf: "Tree Recycles Zones Report #{ Time.now.strftime('%^b-%d %H-%M')}",
        template: "driver/zones/index",
        page_size: 'Letter',
        orientation: "Landscape"
      end
    end
  end

end
