class HomePageController < ApplicationController
  def index
    @collections = Collection.newest(10)
    @collection_items = CollectionItem.newest(10)
  end
end
