class CollectionItem < ApplicationRecord
    belongs_to :collection

    def self.newest count
        order(created_at: :desc).limit(count)
    end
end
