module ApplicationHelper
  include Pagy::Frontend

  def setting
    @setting ||= Setting.first_or_create
  end

  def nice_long_date(date)
    date&.strftime('%A, %B %e, %Y')
  end

  def nice_date(date)
    date&.strftime('%B %e, %Y')
  end

  def nice_time(datetime)
    datetime&.strftime('%l:%M %p')
  end

  def nice_date_time(datetime)
    datetime&.strftime("%B %e, %Y @ %l:%M %p")
  end

  def nice_date_time_no_year(datetime)
    datetime&.strftime("%B %e @ %l:%M %p")
  end

  def nice_short_date_time(datetime)
    datetime&.strftime('%H:%M %F')
  end

  def admin_view?
    request.path.include?('/admin')
  end

  def driver_view?
    request.path.include?('/driver')
  end
end
