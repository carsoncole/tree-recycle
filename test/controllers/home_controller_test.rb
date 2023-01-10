require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get question" do
    get questions_url
    assert_response :success
  end

  test "should get software" do
    get software_url
    assert_response :success
  end

  test "should get index with remind mes enabled" do
    get root_url
    setting.update(is_remind_mes_enabled: true)
    get root_url
    assert_response :success
  end

  test "should get index with reservations closed" do
    get root_url
    setting.update(is_reservations_open: false, reservations_closed_message: 'We are closed')
    get root_url
    assert_response :success
    assert flash[:warning] == 'We are closed'
  end
end
