class Collection < ApplicationRecord
    validates :name, presence: true

    belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
    belongs_to :collection_type
    has_many :user_collections
    belongs_to :parent, class_name: 'Collection', optional: true
    has_many :children, class_name: 'Collection', foreign_key: 'parent_id'
    has_and_belongs_to_many :items

    def self.search val
      if val
        where("name LIKE ?", "%#{val}%")
      end
    end

    def self.newest count
      order(created_at: :desc).limit(count)
    end
end
