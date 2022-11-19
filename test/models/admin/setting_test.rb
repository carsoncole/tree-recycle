require "test_helper"

class Admin::SettingTest < ActiveSupport::TestCase
  test "setting of reservation defaults" do
    reservation = build_stubbed(:reservation)

    assert_equal reservation.city, setting.default_city
    assert_equal reservation.state, setting.default_state
    assert_equal reservation.country, setting.default_country

    assert reservation.valid?
  end
end
