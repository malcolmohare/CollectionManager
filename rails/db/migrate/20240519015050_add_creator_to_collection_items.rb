class AddCreatorToCollectionItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :collection_items, :creator, null: true, foreign_key: { to_table: :users }
  end
end
