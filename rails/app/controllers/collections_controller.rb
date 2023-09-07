class CollectionsController < ApplicationController
  def index
    @collections = Collection.all
  end

  def show
    @collection = Collection.find(params[:id])
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      redirect_to @collection
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def update
    @collection = Collection.find(params[:id])

    if @collection.update(collection_params)
      redirect_to @collection
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def collect
    @collection = Collection.find(params[:id])
    UserCollection.create([{user: current_user, collection: @collection}])
    render :show
  end

  def uncollect
    @collection = Collection.find(params[:id])
    UserCollection.find_by(user_id: current_user.id, collection_id: @collection.id).delete
    render :show
  end

  private
    def collection_params
      params.require(:collection).permit(:name, :collection_type_id)
    end
end
