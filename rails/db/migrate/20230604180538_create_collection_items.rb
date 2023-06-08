class CreateCollectionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :collection_items do |t|
      t.string :name

      t.timestamps
    end
  end
end
