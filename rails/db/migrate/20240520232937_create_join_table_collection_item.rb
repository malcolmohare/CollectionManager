class CreateJoinTableCollectionItem < ActiveRecord::Migration[7.0]
  def change
    create_join_table :collections, :items do |t|
      # t.index [:collection_id, :item_id]
      # t.index [:item_id, :collection_id]
    end
  end
end
