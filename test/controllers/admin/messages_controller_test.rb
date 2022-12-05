require "test_helper"

class Admin::MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create :viewer
    @editor = create :editor
    @administrator = create :administrator
  end

  test "should get index" do
    get admin_messages_url(as: @viewer)
    assert_response :success

    get admin_messages_url(as: @editor)
    assert_response :success

    get admin_messages_url(as: @administrator)
    assert_response :success
  end

  test "not getting index" do 
    get admin_messages_url
    assert_redirected_to :sign_in
  end

  test "should get create" do
    assert_difference('Message.count') do
      post admin_messages_url(message: { number: '+12065551212', body: 'how are you?' }, as: @editor)
    end
    assert_redirected_to admin_messages_path(number: '+12065551212')
  end

  test "should NOT get create" do
    post admin_messages_url(message: { number: '2065551212', body: 'how are you?' },as: @viewer)
    assert_response :unauthorized
  end

  test "should get destroy" do
    delete admin_message_url(create(:message).id, as: @editor)
    assert_redirected_to admin_messages_path
  end

  test "should NOT get destroy" do
    delete admin_message_url(create(:message).id, as: @viewer)
    assert_response :unauthorized
  end
end
