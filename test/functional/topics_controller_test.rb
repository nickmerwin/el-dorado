require File.dirname(__FILE__) + '/../test_helper'
require 'topics_controller'

# Re-raise errors caught by the controller.
class TopicsController; def rescue_action(e) raise e end; end

class TopicsControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = TopicsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:topics)
  end

  def test_should_create_topic
    login_as :trevor
    old_topic_count = Topic.count
    old_post_count = Post.count
    post :create, :topic => { :title => "test", :body => "this is a test" }  
    assert assigns(:topic)
    assert assigns(:post)
    assert_equal old_topic_count+1, Topic.count
    assert_equal old_post_count+1, Post.count
    assert_redirected_to topic_path(assigns(:topic))
  end
  
  def test_must_be_logged_in_to_post_topic
    old_count = Topic.count
    post :create, :topic => { :title => "test", :body => "this is a test" }  
    assert_redirected_to login_path
  end

  def test_should_fail_to_get_new_if_not_logged_in
    get :new
    assert_redirected_to login_path
  end

  def test_should_get_new_if_logged_in
    login_as :trevor
    get :new
    assert_response :success
  end
  
  def test_should_show_topic
    get :show, :id => 1
    assert_response :success
  end

  def test_should_not_show_private_topic_unless_logged_in
    get :show, :id => 2
    assert_redirected_to login_path
  end
  
  def test_should_show_private_topic_if_logged_in
    login_as :trevor
    get :show, :id => 2
    assert_response :success
  end

  def test_should_fail_to_get_edit_unless_user_created_topic
    get :edit, :id => 1
    assert_redirected_to login_path
  end
  
  def test_should_get_edit_if_user_created_topic
    login_as :trevor
    get :edit, :id => 1
    assert_response :success
  end
 
  def test_should_fail_to_update_topic_if_not_authorized
    put :update, :id => 1, :topic => { :title => "bogus!"}
    assert_redirected_to login_path
    assert_equal "Testing", topics(:Testing).title
  end
  
  def test_should_update_topic_if_authorized
    login_as :trevor
    put :update, :id => 1, :topic => { :title => "ok!", :body => "ok!" }
    assert_redirected_to topic_path(assigns(:topic))
    assert_equal "ok!", topics(:Testing).title
  end
  
  def test_should_fail_to_update_topic_if_wrong_user
    login_as :Timothy
    put :update, :id => 1, :topic => { :title => "bogus!" }
    assert_redirected_to topic_path(topics(:Testing))
    assert_equal "Testing", topics(:Testing).title
  end
  
  def test_should_update_topic_if_admin
    login_as :Administrator
    put :update, :id => 1, :topic => { :title => "admin!" }
    assert_redirected_to topic_path(assigns(:topic))
    assert_equal "admin!", topics(:Testing).title
  end

  def test_should_fail_to_destroy_topic_if_not_authorized
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count, Topic.count
    assert_redirected_to login_path
  end
  
  def test_should_destroy_topic_if_user_that_created_topic
    login_as :trevor
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Topic.count
    assert_redirected_to topics_path
  end
  
  def test_should_fail_to_destroy_topic_if_wrong_user
    login_as :Timothy
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count, Topic.count
    assert_redirected_to topic_path(topics(:Testing))
  end
  
  def test_should_destroy_topic_if_admin
    login_as :Administrator
    old_count = Topic.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Topic.count
    assert_redirected_to topics_path
  end
  
  def test_should_redirect_to_topic_with_viewtopic_php_style_url
    get :unknown_request, :path => "viewtopic.php", :id => "1"
    assert_redirected_to topic_path(:id => "1")
  end
  
  def test_should_redirect_to_home_path_if_viewtopic_id_not_found
    # get :unknown_request, :path => "viewtopic.php", :id => "23823"
    # assert_redirected_to topic_path(:id => "23823")
    # assert_redirected_to home_path
  end
  
  def test_should_fail_to_find_topic_with_viewtopic_php_url_if_private_and_not_logged_in
    # get :unknown_request, :path => "viewtopic.php", :id => "2"
    # assert_redirected_to topic_path(:id => "2")
  end
  
  def test_should_find_topic_with_viewtopic_php_url_if_private_and_logged_in
    # login_as :trevor
    # get :unknown_request, :path => "viewtopic.php", :id => "2"
    # assert_redirected_to topic_path(:id => "2")
  end
  
end