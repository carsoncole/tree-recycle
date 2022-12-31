class Admin::AnalyticsController < Admin::AdminController
  def index
    @sources = Reservation.not_archived.heard_about_sources
    @donation_counts = Donation.group(:form).sum(:amount)
    @reservations_count = Reservation.not_archived.count
    
    @donation_online_count = Donation.online.joins(:reservation).where.not("reservations.status IN(0, 4, 99)").count
    @donation_count = @donation_online_count + Donation.not_online.count

    @total_donations_online = Donation.online.joins(:reservation).where.not("reservations.status IN (0,4,99)").sum(:amount)
    @total_donations = @total_donations_online + Donation.not_online.sum(:amount)

    donations_ordered = Donation.joins(:reservation).order(:amount).where.not("reservations.status IN (0,4,99)")
    
      @median_online = if @donation_count == 0
        0
      elsif @donation_count.odd?
        donations_ordered[(@donation_online_count/2.0).ceil].amount
      else
        (donations_ordered[ (@donation_online_count/2.0).ceil ].amount + donations_ordered[ (@donation_online_count/2.0).floor-1 ].amount)/ 2.0
      end
    @average_online_donation = @total_donations_online / @donation_online_count

    @zone_counts = Reservation.not_archived.joins(route: [:zone]).group('zones.name').count

    @route_counts = Reservation.not_archived.joins(:route).group('routes.name').count.sort_by {|_key, value| value}.reverse
  end
end
