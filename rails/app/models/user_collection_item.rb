class UserCollectionItem < ApplicationRecord
  belongs_to :user
  belongs_to :collection_item

  validates :collection_item, uniqueness: { scope: :user }
end
