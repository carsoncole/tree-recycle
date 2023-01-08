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

  test "viewing show" do
    message = create(:message)

    get admin_phone_url(phone: message.phone, as: @viewer)
    assert_response :success
  end

  test "creating a message as administrator" do
    assert_difference('Message.count') do
      post admin_messages_url(message: { phone: '+12065551212', body: 'how are you?' }, as: @administrator)
    end
    assert_redirected_to admin_phone_path(phone: '+12065551212')
  end

  test "creating a message as editor" do
    assert_difference('Message.count') do
      post admin_messages_url(message: { phone: '+12065551212', body: 'how are you?' }, as: @editor)
    end
    assert_redirected_to admin_phone_path(phone: '+12065551212')
  end

  test "should NOT create as viewer" do
    post admin_messages_url(message: { phone: '2065551212', body: 'how are you?' },as: @viewer)
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
