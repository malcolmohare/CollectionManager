class CollectionItemsController < ApplicationController
  def index
    @collection_items = CollectionItem.all
  end

  def show
    @collection_item = CollectionItem.find(params[:id])
  end

  def new
    @collection_item = CollectionItem.new
    @collection_item.collection_id = params[:collection_id] if params[:collection_id].present?
  end

  def create
    @collection_item = CollectionItem.new(collection_item_params)

    if @collection_item.save
      redirect_to @collection_item.collection
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @collection_item = CollectionItem.find(params[:id])
  end

  def update
    @collection_item = CollectionItem.find(params[:id])

    if @collection_item.update(collection_item_params)
      redirect_to @collection_item
    else
      render :edit, status: :unprocessable_entity

    end
  end

  private
    def collection_item_params
      params.require(:collection_item).permit(:name, :collection_id)
    end
end
