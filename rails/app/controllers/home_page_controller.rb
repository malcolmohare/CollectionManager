class HomePageController < ApplicationController
  def index
    @collections = Collection.newest(10)
    @items = Item.newest(10)
  end
end
