require "test_helper"

class RemindMeControllerTest < ActionDispatch::IntegrationTest
  test "should create" do
    post remind_mes_url, params: { reservation: { name: 'jim jones', email: 'jim@example.com'}}
    assert_redirected_to remind_me_url(Reservation.remind_me.first)
  end

  test "should not create" do
    post remind_mes_url, params: { reservation: { email: 'jim@example.com'}}
    assert_redirected_to root_url
  end
end
