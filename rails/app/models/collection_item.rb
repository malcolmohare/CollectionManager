class CollectionItem < ApplicationRecord
    belongs_to :collection

    validates :name, uniqueness: { scope: :collection, message: "collections should not have duplicate entries"}

    def self.newest count
        order(created_at: :desc).limit(count)
    end
end
