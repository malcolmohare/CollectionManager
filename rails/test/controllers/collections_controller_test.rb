require "test_helper"

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    collection = collections(:one)
    get collection_url(collection)
    assert_response :success
  end

  test "should redirect to sign in instead of showing create page" do
    get new_collection_url
    assert_redirected_to new_user_session_url
  end

  class LoggedInUser < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
      sign_in users(:one)
    end

    test "should get new" do
      get new_collection_url
      assert_response :success
    end
  
    test "should create collection" do
      assert_difference('Collection.count') do
        post collections_url, params: { collection: { name: 'New Collection', collection_type_id: collection_types(:one).id } }
      end
  
      assert_redirected_to collection_url(Collection.last)
    end
  
    test "should get edit" do
      collection = collections(:one)
      get edit_collection_url(collection)
      assert_response :success
    end
  
    test "should update collection" do
      collection = collections(:one)
      patch collection_url(collection), params: { collection: { name: 'Updated Collection' } }
      assert_redirected_to collection_url(collection)
    end
  
    test "should collect" do
      collection = collections(:one)
      assert_difference('UserCollection.count') do
        get collect_collection_url(collection)
      end
  
      assert_response :success
    end
  
    test "should uncollect" do
      collection = collections(:one)
      user_collection = UserCollection.create(user: users(:one), collection: collection)
      assert_difference('UserCollection.count', -1) do
        get uncollect_collection_url(collection)
      end
  
      assert_response :success
    end
  
    test "should get bulk_create_items" do
      collection = collections(:one)
      get bulk_create_items_url(collection)
      assert_response :success
    end
  
    test "should process_bulk_create_items" do
      collection = collections(:one)
      assert_difference('CollectionItem.count', 3) do
        post process_bulk_create_items_url(collection), params: { items: 'Item 1, Item 2, Item 3' }
      end
  
      assert_response :success
    end

    class NotCollectionOwner < ActionDispatch::IntegrationTest
      include Devise::Test::IntegrationHelpers
  
      def setup
        sign_in users(:two)
      end

      test "should not get edit" do
        collection = collections(:one)
        get edit_collection_url(collection)
        assert_redirected_to collections_url
      end
    
      test "should not update collection" do
        collection = collections(:one)
        patch collection_url(collection), params: { collection: { name: 'Updated Collection' } }
        assert_redirected_to collections_url
      end
    
      test "should not get bulk_create_items" do
        collection = collections(:one)
        get bulk_create_items_url(collection)
        assert_redirected_to collections_url
      end
    
      test "should not process_bulk_create_items" do
        collection = collections(:one)
        post process_bulk_create_items_url(collection), params: { items: 'Item 1, Item 2, Item 3' }
        assert_redirected_to collections_url
      end
    end
  end

  
end
