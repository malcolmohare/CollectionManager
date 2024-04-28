require "test_helper"

class CollectionTypesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
    
  setup do
    @collection_type = collection_types(:one)
  end

  test "should get index" do
    get collection_types_url
    assert_response :success
  end

  test "should get show" do
    get collection_type_url(@collection_type)
    assert_response :success
  end

  test "when user not logged in get new should redirect to sign in" do
    get new_collection_type_url
    assert_redirected_to new_user_session_url
  end

  test "when user logged in should get new" do
    sign_in users(:one)
    get new_collection_type_url
    assert_response :success
  end

  test "when user not logged post to create should redirect to sign in" do
    post collection_types_url, params: { collection_type: { name: "Test Collection Type" } }
    assert_redirected_to new_user_session_url
  end

  test "when used logged in should create collection_type" do
    sign_in users(:one)
    assert_difference('CollectionType.count') do
      post collection_types_url, params: { collection_type: { name: "Test Collection Type" } }
    end

    assert_redirected_to collection_type_url(CollectionType.last)
  end
end