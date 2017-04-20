require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do 
    get signup_path 
    assert_no_difference 'User.count' do 
      post users_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar"} }
    end 
    assert_template 'users/new' #failed submission re-renders /new#
  end 
  
  test "valid signup information" do 
    get signup_path 
    assert_difference 'User.count', 1 do 
      post users_path, params: { user: { name: "Ben",
                                      email: "ben@gmail.com",
                                      password: "foobar",
                                      password_confirmation: "foobar"} } 
      end 
    follow_redirect! 
    assert_template 'users/show' #checks that submission renders /show 
  end 
end
