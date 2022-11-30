class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def show
    @order = Order.find(params[:id])
    @order.shipping_cost = 800
    @total = 0
    @order.order_details.each do |order_detail|
    	@total += order_detail.subtotal
	  end
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    flash[:notice] = "注文ステータスの変更しました"

    #注文ステータスが"入金確認"になったら製作ステータスを"製作待ち"
    if @order.status_i18n == "入金確認"
      @order.order_details.each do |order_detail|
        order_detail.update(making_status: 1)
      end
    end
    redirect_to admin_order_path(@order)
  end


   private
  # ストロングパラメータ
  def order_params
    params.require(:order).permit(:customer_id, :order_detail_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
  end
end
