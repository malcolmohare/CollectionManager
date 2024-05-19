class CollectionItem < ApplicationRecord
    belongs_to :collection
    belongs_to :creator, class_name: 'User'

    validates :name, uniqueness: { scope: :collection, message: "collections should not have duplicate entries"}

    def self.newest count
        order(created_at: :desc).limit(count)
    end
end
