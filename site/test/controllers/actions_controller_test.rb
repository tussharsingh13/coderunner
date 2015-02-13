require 'test_helper'

class ActionsControllerTest < ActionController::TestCase
  test "should get submit" do
    get :submit
    assert_response :success
  end

  test "should get editor" do
    get :editor
    assert_response :success
  end

end
