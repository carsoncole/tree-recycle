require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get not_found 404" do
    get "/404"
    assert_response :not_found
    assert_response 404
  end

  test "should get internal_server_error 500" do
    get '/500'
    assert_response :internal_server_error
    assert_response 500
  end

  test "should get 422 error" do
    get '/422'
    assert_response :unprocessable_entity
    assert_response 422
  end

  test "raising a not found error" do 
    assert_raise ActiveRecord::RecordNotFound do
      get reservation_url("bogus id")
    end
  end
end
