class ItemsController < BaseController

  before_action :redirect_if_not_logged_in, only: [:new, :create, :edit, :update, :collect, :uncollect]

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    @item.collection_id = params[:collection_id] if params[:collection_id].present?
  end

  def create
    @item = Item.new(item_params)
    @item.creator = current_user
    @item.collections << Collection.find(item_params[:collection_id])

    if @item.save
      redirect_to @item.collection
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @item = Item.find(params[:id])
    redirect_to items_path, notice: "Not authorized" if @item.creator != current_user
  end

  def update
    @item = Item.find(params[:id])
    if @item.creator != current_user
      redirect_to items_path, notice: "Not authorized"
      return
    end

    if @item.update(item_params)
      redirect_to @item
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def collect
    @item = Item.find(params[:id])
    UserItem.create([{user: current_user, item: @item}])
    render :show
  end

  def uncollect
    @item = Item.find(params[:id])
    UserItem.find_by(user_id: current_user.id, item_id: @item.id).delete
    render :show
  end

  private
    def item_params
      params.require(:item).permit(:name, :collection_id)
    end
end
