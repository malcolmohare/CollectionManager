namespace :db do
    desc "Backfill data from items to join table"
    task backfill_collection_items: :environment do
      Item.find_each do |item|
        if item.collection_id
          item.collections << Collection.find(item.collection_id)
        end
      end
    end
  end