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
end
