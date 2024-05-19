require "test_helper"

class CollectionItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @collection_item = collection_items(:one)
    @user = users(:one)
  end

  test "should redirect update when not logged in" do
    patch collection_item_url(@collection_item), params: { collection_item: { name: "New Name" } }
    assert_redirected_to new_user_session_url
  end

  test "should redirect update when not authorized" do
    sign_in users(:two)
    patch collection_item_url(@collection_item), params: { collection_item: { name: "New Name" } }
    assert_redirected_to collection_items_url
    assert_not flash.empty?
  end

  test "should update collection item when logged in and authorized" do
    sign_in @collection_item.creator
    patch collection_item_url(@collection_item), params: { collection_item: { name: "New Name" } }
    assert_redirected_to collection_item_url(@collection_item)
    @collection_item.reload
    assert_equal "New Name", @collection_item.name
  end
end