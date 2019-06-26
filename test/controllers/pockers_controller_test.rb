require 'test_helper'

class PockersControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get pockers_top_url
    assert_response :success
  end

end
