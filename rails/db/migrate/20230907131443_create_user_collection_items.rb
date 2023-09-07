class CreateUserCollectionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_collection_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :collection_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
