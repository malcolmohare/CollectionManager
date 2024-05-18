class AddCreatorToCollections < ActiveRecord::Migration[7.0]
  def change
    add_reference :collections, :creator, null: true, foreign_key: { to_table: :users }
  end
end
