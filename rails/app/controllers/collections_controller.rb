class CollectionsController < BaseController
  before_action :redirect_if_not_logged_in, only: [:new, :create, :edit, :update, :collect, :uncollect, :bulk_create_items, :process_bulk_create_items]

  def index
    if params[:search].present?
      @collections = Collection.search(params[:search])
    else
      @collections = Collection.all
    end
  end

  def show
    @collection = Collection.find(params[:id])
    if params[:search]
      @items = Item.joins(:collections)
                   .where('items.name LIKE ?', "%#{params[:search]}%")
                   .where(collections: { collection_type: @collection.collection_type })
                   .where.not(id: @collection.items.pluck(:id))
                   .distinct
    else
      @items = []
    end
  end

  def add_item
    @collection = Collection.find(params[:id])
    @item = Item.find(params[:item_id])
    @collection.items << @item unless @collection.items.include?(@item)
    redirect_to @collection
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.creator = current_user

    if @collection.save
      redirect_to @collection
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @collection = Collection.find(params[:id])
    redirect_to collections_path, notice: "Not authorized" if @collection.creator != current_user
  end

  def update
    @collection = Collection.find(params[:id])
    if @collection.creator != current_user
      redirect_to collections_path, notice: "Not authorized"
      return
    end

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

  def bulk_create_items
    @collection = Collection.find(params[:id])
    redirect_to collections_path, notice: "Not authorized" if @collection.creator != current_user
  end

  def process_bulk_create_items
    @collection = Collection.find(params[:id])
    if @collection.creator != current_user
      redirect_to collections_path, notice: "Not authorized"
      return
    end
    items = params[:items]
    items.split(",").map{ |x| x.strip }.each do |item_name|
      item = Item.new(name: item_name, creator: current_user, collection: @collection)
      item.collections << @collection
      item.save!
    end
    render :show
  end

  private
    def collection_params
      params.require(:collection).permit(:name, :collection_type_id, :parent_id)
    end
end
