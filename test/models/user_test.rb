require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup 
    @user = User.new(name: "Example User", email: "user@example.com", 
                password: "foobar", password_confirmation: "foobar")
  end 
  
  test "should be valid" do
    assert @user.valid?
  end 
  
  #####test cases for name ####################
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end 
  
  test "name should not be too long" do 
    @user.name = "a" * 51 
    assert_not @user.valid? 
  end 
  
  #####test cases for email####################
  test "email should be present" do 
    @user.email = "   "
    assert_not @user.valid? 
  end 
  
  test "email should not be too long" do 
    @user.email = "a" * 244 + "@example.com" 
    assert_not @user.valid? 
  end 
  
  test "email validation should accept valid addresses" do 
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn] 
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end 
  end 
  
  test "email_addresses should be unique" do 
    duplicate_user = @user.dup 
    duplicate_user.email = @user.email.upcase 
    @user.save 
    assert_not duplicate_user.valid? 
  end
  
  test "email addresses should be saved as lower-case" do 
    mixed_case_email = "Foo@ExAMPle.CoM" 
    @user.email = mixed_case_email 
    @user.save 
    assert_equal mixed_case_email.downcase, @user.reload.email 
  end 
  
  ######test cases for password##################
  test "password should be present (nonblank)" do 
    @user.password = @user.password_confirmation = " " * 6 
    assert_not @user.valid? 
  end 
  
  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5 
    assert_not @user.valid? 
  end 
  
  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?(:remember, '')
  end 
  
  test "associated rants should be destroyed" do 
    @user.save 
    @user.rants.create!(content: "Lorem Ipsum")
    assert_difference 'Rant.count', -1 do 
      @user.destroy 
    end
  end 
  
  test "should follow and unfollow a user" do 
    jeff = users(:john)
    dean = users(:dean)
    assert_not dean.following?(jeff)
    dean.follow(jeff)
    assert dean.following?(jeff)
    assert jeff.followers.include?(dean)
    dean.unfollow(jeff)
    assert_not dean.following?(jeff)
  end 
  
  test "feed should have the right posts" do
    john = users(:john)
    dean  = users(:dean)
    jeff    = users(:jeff)
    # Posts from followed user
    #jeff.rants.each do |post_following|
   #   assert john.feed.include?(post_following)
    #end
    # Posts from self
    john.rants.each do |post_self|
      assert john.feed.include?(post_self)
    end
    # Posts from unfollowed user
    dean.rants.each do |post_unfollowed|
      assert_not john.feed.include?(post_unfollowed)
    end
  end
  
  
end
