class Public::CartItemsController < ApplicationController
  def index
    @cart_items = current_customer.cart_items
    @total = 0
    #@total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
  end

  def update
    @cart_items = CartItem.find(params[:id])
    if @cart_items.update(cart_item_params)
     flash[:notice] = "変更を保存しました"
     redirect_to cart_items_path
    end
  end

  def destroy_all
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    flash[:notice] = "カートを空にしました"
    redirect_to cart_items_path
  end

  def destroy
    #@cart_item = CartItem.find_by(item_id: params[:cart_item][:item_id], customer_id: current_customer.id)
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash[:notice] = "削除しました"
    redirect_to cart_items_path
  end

  def create
    # @cart_itemを定義（find_byでどの情報のアイテムを持ってくるのかパラメータを参考に記述）
     @cart_item = CartItem.find_by(item_id: params[:cart_item][:item_id], customer_id: current_customer.id)
    #初めて対象商品をカートに追加する場合
    if @cart_item.blank?
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      @cart_item.save
      flash[:notice] = '商品が追加されました。'
      redirect_to cart_items_path
    else
    #すでに追加する商品がカートにある場合
      @cart_item.amount += params[:cart_item][:amount].to_i
      @cart_item.customer_id = current_customer.id
      @cart_item.save
      flash[:notice] = '商品が追加されました。'
      redirect_to cart_items_path
    end
  end

   private
  def cart_item_params
      params.require(:cart_item).permit(:customer_id, :item_id, :amount, :item_image)
  end
end
