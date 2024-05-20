require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @item = items(:one)
    @user = users(:one)
  end

  test "should redirect update when not logged in" do
    patch item_url(@item), params: { item: { name: "New Name" } }
    assert_redirected_to new_user_session_url
  end

  test "should redirect update when not authorized" do
    sign_in users(:two)
    patch item_url(@item), params: { item: { name: "New Name" } }
    assert_redirected_to items_url
    assert_not flash.empty?
  end

  test "should update collection item when logged in and authorized" do
    sign_in @item.creator
    patch item_url(@item), params: { item: { name: "New Name" } }
    assert_redirected_to item_url(@item)
    @item.reload
    assert_equal "New Name", @item.name
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    sign_in @user
    assert_difference('Item.count') do
      post items_url, params: { item: { name: "New Item", collection_id: @item.collection_id } }
    end

    assert_redirected_to collection_url(@item.collection)
  end

  test "should not create item if not logged in" do
    assert_no_difference('Item.count') do
      post items_url, params: { item: { name: "New Item", collection_id: @item.collection_id } }
    end

    assert_redirected_to new_user_session_url
  end

  test "should get edit" do
    sign_in @user
    get edit_item_url(@item)
    assert_response :success
  end

  test "should not get edit if not authorized" do
    sign_in users(:two)
    get edit_item_url(@item)
    assert_redirected_to items_url
    assert_not_nil flash[:notice]
  end

  test "should update item" do
    sign_in @user
    patch item_url(@item), params: { item: { name: "Updated Item" } }
    assert_redirected_to item_url(@item)
    @item.reload
    assert_equal "Updated Item", @item.name
  end

  test "should not update item if not authorized" do
    sign_in users(:two)
    patch item_url(@item), params: { item: { name: "Updated Item" } }
    assert_redirected_to items_url
    assert_not_nil flash[:notice]
  end

  test "should collect item" do
    item = items(:two)
    sign_in @user
    assert_difference('UserItem.count') do
      get collect_item_url(item)
    end
    assert_response :success
  end

  test "should uncollect item" do
    sign_in @user
    UserItem.create(user: @user, item: @item)
    assert_difference('UserItem.count', -1) do
      get uncollect_item_url(@item)
    end
    assert_response :success
  end
end