class UserCollectionItem < ApplicationRecord
  belongs_to :user
  belongs_to :collection_item
end
