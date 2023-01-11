require "test_helper"

class Admin::ReadMesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create(:viewer)
    @editor = create(:editor)
    @administrator = create(:administrator)
  end

  test "viewing index as admin" do
    get admin_remind_mes_path(as: @administrator)
    assert_response :success
  end

  test "viewing index as viewer" do
    get admin_remind_mes_path(as: @viewer)
    assert_response :success
  end

  test "viewing index as editor" do
    get admin_remind_mes_path(as: @editor)
    assert_response :success
  end

  test "viewing index" do
    get admin_remind_mes_path
    assert_redirected_to sign_in_path
  end

  test "destroying as admin" do
    @remind_me = create(:remind_me)
    delete admin_remind_me_path(@remind_me, as: @administrator)
    assert_redirected_to admin_remind_mes_path
    assert_equal 0, Reservation.remind_me.count
  end

  test "destroying as editor" do
    @remind_me = create(:remind_me)
    delete admin_remind_me_path(@remind_me, as: @editor)
    assert_redirected_to admin_remind_mes_path
    assert_equal 0, Reservation.remind_me.count
  end

  test "destroying as viewer" do
    @remind_me = create(:remind_me)
    delete admin_remind_me_path(@remind_me, as: @viewer)
    assert_response :unauthorized
    assert_equal 1, Reservation.remind_me.count
  end

  test "destroying" do
    @remind_me = create(:remind_me)
    delete admin_remind_me_path(@remind_me)
    assert_redirected_to sign_in_path
  end
end
