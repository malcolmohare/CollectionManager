class RelateCollectionsAndItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :collection_items, :collection, foreign_key: true
  end
end
