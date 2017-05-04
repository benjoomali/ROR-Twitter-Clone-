require 'test_helper'

class RantTest < ActiveSupport::TestCase
  
  def setup 
    @user = users(:john)
    @rant = @user.rants.build(content: "Lorem Ipsum")
  end
  
  test "should be valid" do
    assert @rant.valid? 
  end 
  
  test "user id should be present" do 
    @rant.user_id = nil 
    assert_not @rant.valid? 
  end 
  
  test "content should not be empty" do 
    @rant.content = "   "
    assert_not @rant.valid? 
  end 
  
  test "content should be at most 140 characters" do
    @rant.content = "a" * 141 
    assert_not @rant.valid? 
  end 
  
  test "content should be most recent first" do 
    assert_equal rants(:most_recent), Rant.first 
  end 
  
  
end
