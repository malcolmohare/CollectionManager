class RenameCollectionItemsToItems < ActiveRecord::Migration[7.0]
  def change
    rename_table :collection_items, :items
    rename_table :user_collection_items, :user_items
    rename_column :user_items, :collection_item_id, :item_id
  end
end
