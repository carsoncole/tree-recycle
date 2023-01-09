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

  def nice_short_date(datetime) # Jan 09 '23
    datetime&.strftime("%b %e '%y")
  end

  def nice_long_date_short(date)
    date&.strftime('%a, %b %e')
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

  def markdown(text)
    options = [:hard_wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks, :underline, :highlight,
               :no_images, :filter_html, :safe_links_only, :prettify, :no_styles]
    Markdown.new(text, *options).to_html.html_safe
  end
end
