require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end
  # test "the truth" do
  #   assert true
  # end
  test "login with invalid info" do
    get login_path #verify login path
    assert_template 'sessions/new' #verify that new sessions renders properly 
    post login_path, params: { session: { email: "", password: "" } } #post to sessions path with invalid
    assert_template 'sessions/new' #verify re render of new 
    assert_not flash.empty? #verify flash appears 
    get root_path 
    assert flash.empty? #verify flash does not appear
  end 
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    delete logout_path 
    assert_not is_logged_in?
    assert_redirected_to root_url 
    follow_redirect!
    assert_select "a[href=?]", login_path 
    assert_select "a[href=?]", logout_path, count: 0 
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end