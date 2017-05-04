require 'test_helper'

class RantsControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @rant = rants(:orange)
  end 
  
  test "should redirect create when logged in" do
    assert_no_difference "Rant.count" do 
      post rants_path, params: { rant: { content: "Lorem ipsum" } }
    end 
    assert_redirected_to login_url 
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Rant.count' do 
      delete rant_path(@rant)
    end 
    assert_redirected_to login_url 
  end 
  
  test "should redirect destroy for wrong rant" do 
    log_in_as(users(:jeff))
    rant = rants(:ants)
    assert_no_difference 'Rant.count' do 
      delete rant_path(rant)
    end 
    assert_redirected_to root_url
  end
  
end
