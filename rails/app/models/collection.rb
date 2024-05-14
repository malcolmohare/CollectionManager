class Collection < ApplicationRecord
    validates :name, presence: true
    alias_attribute :items, :collection_items

    belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
    belongs_to :collection_type
    has_many :collection_items
    has_many :user_collections

    def self.search val
      if val
        where("name LIKE ?", "%#{val}%")
      end
    end

    def self.newest count
      order(created_at: :desc).limit(count)
    end
end
