class Admin::ItemsController < ApplicationController

  def index
    @items = Item.page(params[:page])
    @genre = Genre.page(params[:page])
  end

  def new
    @item = Item.new
    @genres = Genre.all
  end

  def create
    @item = Item.new(item_params)
    @genres = Genre.all
    if @item.save
      flash[:notice] = "新規登録しました"
      redirect_to admin_item_path(@item.id)
    else
      flash[:notice] = "必要事項を入力して下さい"
      render :new
    end
  end


  def show
    @item = Item.find(params[:id])
    @genre = @item.genre
  end

  def edit
    @item = Item.find(params[:id])
    @genres = Genre.all
  end

  def update
    @genre = Genre.find(params[:id])
    @item = Item.find(params[:id])
    if @item.update(item_params)
    flash[:notice] = "変更を保存しました"
    redirect_to admin_items_path
    else
       flash[:notice] = "変更内容を入力して下さい"
      render :edit
    end
  end

   private
  # ストロングパラメータ
  def item_params
    params.require(:item).permit(:name, :image, :introduction, :price, :is_active, :genre_id)
  end

end
