class RelateCollectionsAndTypes < ActiveRecord::Migration[7.0]
  def change
    add_reference :collections, :collection_type, foreign_key: true
  end
end
