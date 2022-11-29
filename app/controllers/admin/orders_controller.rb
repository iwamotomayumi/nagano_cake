class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @order.shipping_cost = 800
    @total = 0
    @order.order_details.each do |order_detail|
    	@total += order_detail.subtotal
	  end
  end

   private
  # ストロングパラメータ
  def order_params
    params.require(:order).permit(:customer_id, :order_detail_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
  end
end
