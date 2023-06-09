class Collection < ApplicationRecord
    validates :name, presence: true
    alias_attribute :items, :collection_items

    belongs_to :collection_type
    has_many :collection_items
end
