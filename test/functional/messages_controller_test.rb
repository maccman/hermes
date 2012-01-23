require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = FactoryGirl.create(:message)
    @controller.stubs(:keepsafe).returns(true)
    
    @current_user = FactoryGirl.create(:user)
    @controller.stubs(:current_user).returns(@current_user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, message: @message.attributes
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should show message" do
    get :show, id: @message
    assert_response :success
  end

  test "should update message" do
    put :update, id: @message, message: {read: true}
    assert_redirected_to message_path(assigns(:message))
  end
end