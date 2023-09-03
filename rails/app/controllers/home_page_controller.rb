class HomePageController < ApplicationController
  def index
    @collections = Collection.all
  end
end
