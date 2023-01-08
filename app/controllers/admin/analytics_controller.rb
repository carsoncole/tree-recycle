class Admin::AnalyticsController < Admin::AdminController
  def index
    @sources = Reservation.not_archived.heard_about_sources
    @sources_count = Reservation.not_archived.group(:heard_about_source).count.sort_by {|_key, value| value}.reverse
    @donation_counts = Donation.group(:form).sum(:amount)
    @reservations_count = Reservation.not_archived.count
    
    @donation_online_count = Donation.online.joins(:reservation).where.not("reservations.status IN (0,4,99)").count

    @donation_count = @donation_online_count + Donation.not_online.count

    @total_donations_online = Donation.online.joins(:reservation).where.not("reservations.status IN (99)").sum(:amount)

    @total_no_donation_reservations_count = Reservation.no_donation.count

    @total_cash_check_reservations_count = Reservation.not_archived.where.not(id: Donation.all.map {|d| d.reservation_id}).count - @total_no_donation_reservations_count

    @total_donations = Donation.sum(:amount)

    @total_offline_donations = @total_donations - @total_donations_online
    @average_offline_donation = @total_offline_donations / @total_cash_check_reservations_count.to_f

    online_donations_ordered = Donation.online.joins(:reservation).order(:amount).where.not("reservations.status IN (99)")
    
    @median_online = if @donation_online_count == 0
      0
    elsif @donation_online_count.odd?
      online_donations_ordered[(@donation_online_count/2.0).ceil-1].amount
    else
      (online_donations_ordered[ (@donation_online_count/2.0).ceil-1].amount + online_donations_ordered[ (@donation_online_count/2.0).floor-1 ].amount)/ 2.0
    end

    @average_online_donation = @total_donations_online / @donation_online_count

    @zone_counts = Reservation.not_archived.joins(route: [:zone]).group('zones.name').count

    @route_counts = Reservation.not_archived.joins(:route).group('routes.name').count.sort_by {|_key, value| value}.reverse

    @recycler_counts = Reservation.not_archived.group(:years_recycling).count
    @recycler_counts.each {|key, count| @recycler_counts[key] = (count / @reservations_count.to_f * 100).round(1) }
  end
end
