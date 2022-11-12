require "test_helper"

class Admin::SettingTest < ActiveSupport::TestCase
  test "setting of reservation defaults" do
    settings = create(:setting)
    reservation = build_stubbed(:reservation)

    assert_equal reservation.city, settings.default_city
    assert_equal reservation.state, settings.default_state
    assert_equal reservation.country, settings.default_country

    assert reservation.valid?
  end
end
