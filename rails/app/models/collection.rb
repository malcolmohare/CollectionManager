class Collection < ApplicationRecord
    validates :name, presence: true

    belongs_to :collection_type
end
