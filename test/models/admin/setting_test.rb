require "test_helper"

class Admin::SettingTest < ActiveSupport::TestCase
  test "setting of reservation defaults" do
    reservation = build_stubbed(:reservation)

    assert_equal DEFAULT_CITY, reservation.city
    assert_equal DEFAULT_STATE, reservation.state
    assert_equal DEFAULT_COUNTRY, reservation.country

    assert reservation.valid?
  end
end
