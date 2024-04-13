require "test_helper"

class CollectionTypesControllerTest < ActionDispatch::IntegrationTest
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

  test "should get new" do
    get new_collection_type_url
    assert_response :success
  end

  test "should create collection_type" do
    assert_difference('CollectionType.count') do
      post collection_types_url, params: { collection_type: { name: "Test Collection Type" } }
    end

    assert_redirected_to collection_type_url(CollectionType.last)
  end
end