class Public::OrdersController < ApplicationController

  # 購入情報の入力画面で、宛先や住所などを入力するところ
  def new
    @order = Order.new
  end

    # new 画面から渡ってきたデータをユーザーに確認してもらいます
  def confirm
    @order = Order.new(order_params)
    @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用します
    @total = 0
# 合計金額を出す処理です sum_price はモデルで定義したメソッドです

# new 画面から渡ってきたデータを @order に入れます
    if params[:order][:address_number] == "1"
# view で定義している address_number が"1"だったときにこの処理を実行します
# form_with で @order で送っているので、order に紐付いた address_number となります。以下同様です
     @order.name = current_customer.id # @order の各カラムに必要なものを入れます
     @order.address = current_customer.address
    elsif params[:order][:address_number] == "2"
# view で定義している address_number が"2"だったときにこの処理を実行します
    if Address.exists?(name: params[:order][:customer])
# registered は viwe で定義しています
       @order.name = Address.find(params[:order][:customer]).name
        @order.address = Address.find(params[:order][:customer]).address
    else
       render :new
# 既存のデータを使っていますのでありえないですが、万が一データが足りない場合は new を render します
    end
    elsif params[:order][:address_number] == "3"
# view で定義している address_number が"3"だったときにこの処理を実行します
     address_new = current_customer.addresses.new(address_params)
    if address_new.save # 確定前(確認画面)で save してしまうことになりますが、私の知識の限界でした
    else
        render :new
# ここに渡ってくるデータはユーザーで新規追加してもらうので、入力不足の場合は new に戻します
    end
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
       order_item = OrderItem.new
       order_item.item_id = cart.item_id
       order_item.order_id = @order.id
       order_item.order_amount = cart.amount
# 購入が完了したらカート情報は削除するのでこちらに保存します
       order_item.order_price = cart.item.price
# カート情報を削除するので item との紐付けが切れる前に保存します
        order_item.save
      end
      redirect_to  orders_thanks_path
      cart_items.destroy_all
# ユーザーに関連するカートのデータ(購入したデータ)をすべて削除します(カートを空にする)
    else
      @order = Order.new(order_params)
      render :new
    end
  end


  def thanks
  end

  def index
  end

  def show
  end

  private

  def order_params
    params.require(:order).permit(:cart_item_id, :customer_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status, :cart_item_image)
  end

  def address_params
    params.require(:order).permit(:name, :address)
  end

end
