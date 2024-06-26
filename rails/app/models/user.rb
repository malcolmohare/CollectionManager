class User < ApplicationRecord
  validates :name, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_collections
  has_many :user_items
  has_many :created_collections, class_name: 'Collection', foreign_key: 'creator_id'
  has_many :created_items, class_name: 'Item', foreign_key: 'creator_id'
end
