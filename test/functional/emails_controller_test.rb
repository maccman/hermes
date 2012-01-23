require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  test "creates messages" do
    headers = {}
    text    = "An awesome message"
    
    post :create, to: 'maccman@example.com', 
                  from: 'mike@example.com', 
                  headers: headers, text: text
                  
    assert_response :success
    
    message = Message.last
    assert_equal message.body, text
  end
end
