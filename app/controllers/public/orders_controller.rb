class Public::OrdersController < ApplicationController

  # 購入情報の入力画面で、宛先や住所などを入力するところ
  def new
    @order = Order.new
  end

    # new 画面から渡ってきたデータをユーザーに確認してもらいます
  def confirm
    @order = current_customer.orders.new(order_params)
    @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用します
    @order.shipping_cost = 800
    @total = 0


# 合計金額を出す処理です sum_price はモデルで定義したメソッドです

# new 画面から渡ってきたデータを @order に入れます
# view で定義している address_number が"1"だったときにこの処理を実行します
# form_with で @order で送っているので、order に紐付いた address_number となります。以下同様です
    if params[:order][:address_number] == "0"
        @order.postal_code = current_customer.postal_code
        @order.address = current_customer.address
        @order.name = current_customer.last_name + current_customer.first_name

    elsif params[:order][:address_number] == "1"
        @address = Address.find(params[:order][:address_id])
        @order.postal_code = @address.postal_code
        @order.address = @address.address
        @order.name = @address.name

# 既存のデータを使っていますのでありえないですが、万が一データが足りない場合は new を render します

    elsif params[:order][:address_number] == "2"
        @address = Address.new

    else
        render :new
# ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻します
    end

  end



# 購入を確定
  def create # Order に情報を保存
    cart_items = current_customer.cart_items.all
# ログインユーザーのカートアイテムをすべて取り出して cart_items に入れる
  @order = current_customer.orders.new(order_params)
# 渡ってきた値を @order に入れる
    if @order.save
# ここに至るまでの間にチェックは済ませているが、念の為IF文で分岐
      cart_items.each do |cart|
# 取り出したカートアイテムの数繰り返します
# order_item にも一緒にデータを保存する必要があるのでここで保存します
       order_detail = OrderDetail.new
       order_detail.item_id = cart.item_id
       order_detail.order_id = @order.id
       order_detail.amount = cart.amount
# 購入が完了したらカート情報は削除するのでこちらに保存します
       order_detail.price = cart.item.price
# カート情報を削除するので item との紐付けが切れる前に保存します
        order_detail.save
      end
      redirect_to orders_thanks_path
      cart_items.destroy_all
# ユーザーに関連するカートのデータ(購入したデータ)をすべて削除します(カートを空にする)
    else
      render :new
    end
  end


  def thanks
  end

  def index
    @orders = current_customer.orders.all
  end

  def show
    @order = current_customer.orders.find(params[:id])
    @order.shipping_cost = 800
    @total = 0
    @order.order_details.each do |order_detail|
    	@total += order_detail.subtotal
	end
  end

  private

  def order_params
    params.require(:order).permit(:item_id, :cart_item_id, :customer_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status, :cart_item_image)
  end

  def address_params
    params.require(:order).permit(:name, :address)
  end

end
