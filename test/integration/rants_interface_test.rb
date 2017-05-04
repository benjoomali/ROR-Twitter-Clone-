require 'test_helper'

class RantsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:dean)
  end

  test "rant interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Rant.count' do
      post rants_path, params: { rant: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This rant really ties the room together"
    assert_difference 'Rant.count', 1 do
      post rants_path, params: { rant: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_rant = @user.rants.paginate(page: 1).first
    assert_difference 'Rant.count', -1 do
      delete rant_path(first_rant)
    end
    # Visit different user (no delete links)
    get user_path(users(:jeff))
    assert_select 'a', text: 'delete', count: 0
  end
end
