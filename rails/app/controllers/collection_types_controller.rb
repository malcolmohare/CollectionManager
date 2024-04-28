class CollectionTypesController < BaseController
  before_action :redirect_if_not_logged_in, only: [:new, :create]
  
  def index
    @collection_types = CollectionType.all
  end

  def show
    @collection_type = CollectionType.find(params[:id])
  end

  def new
    @collection_type = CollectionType.new
  end

  def create
    @collection_type = CollectionType.new(collection_type_params)

    if @collection_type.save
      redirect_to @collection_type
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def collection_type_params
    params.require(:collection_type).permit(:name)
  end
end
