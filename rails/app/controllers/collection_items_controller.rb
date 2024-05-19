class CollectionItemsController < BaseController

  before_action :redirect_if_not_logged_in, only: [:new, :create, :edit, :update, :collect, :uncollect]

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
    @collection_item.creator = current_user

    if @collection_item.save
      redirect_to @collection_item.collection
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @collection_item = CollectionItem.find(params[:id])
    redirect_to collection_items_path, notice: "Not authorized" if @collection_item.creator != current_user
  end

  def update
    @collection_item = CollectionItem.find(params[:id])
    if @collection_item.creator != current_user
      redirect_to collection_items_path, notice: "Not authorized"
      return
    end

    if @collection_item.update(collection_item_params)
      redirect_to @collection_item
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def collect
    @collection_item = CollectionItem.find(params[:id])
    UserCollectionItem.create([{user: current_user, collection_item: @collection_item}])
    render :show
  end

  def uncollect
    @collection_item = CollectionItem.find(params[:id])
    UserCollectionItem.find_by(user_id: current_user.id, collection_item_id: @collection_item.id).delete
    render :show
  end

  private
    def collection_item_params
      params.require(:collection_item).permit(:name, :collection_id)
    end
end
