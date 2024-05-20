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
end