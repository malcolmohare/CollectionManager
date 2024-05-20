class AddParentIdToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :parent_id, :integer
    add_index :collections, :parent_id
  end
end
