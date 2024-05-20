# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

return if Rails.env == "production"

UserItem.destroy_all
UserCollection.destroy_all
Item.destroy_all
Collection.destroy_all
CollectionType.destroy_all
User.destroy_all
collection_types = CollectionType.create([{name: "Video Games"}, {name: "Miniature Games"}, {name: "Board Games"}])
collections = Collection.create([
  {name: "NES", collection_type: collection_types[0]},
  {name: "Star Wars: Legion", collection_type: collection_types[1]},
  {name: "Catan", collection_type: collection_types[2]}
])
items = Item.create([{name: "Duck Hunt", collection: collections[0]}, {name: "Super Mario Bros.", collection: collections[0]}])

user = User.create! :name => 'John Doe', :email => 'john@doe.com', :password => 'test1234', :password_confirmation => 'test1234'

UserCollection.create([
  {user: user, collection: collections[0]}
])

UserItem.create([
  {user: user, item: items[0]}
])
