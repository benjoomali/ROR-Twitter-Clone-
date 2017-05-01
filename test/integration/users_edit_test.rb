require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup 
    @user = users(:john)
  end 
  
  test "unsuccessful edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } } 
    assert_template 'users/edit'
  end 
  
  test "successful edit with intended forwarding" do 
    get edit_user_path(@user) 
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    #left password and confirmation blank for users that don't want to update those 
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } } 
    assert_not flash.empty? #make sure error message is not empty 
    assert_redirected_to @user #redirect to profile page 
    @user.reload 
    assert_equal name, @user.name 
    assert_equal email, @user.email 
  end 
end
