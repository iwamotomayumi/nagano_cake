class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: params[:order])

  end

   private
  # ストロングパラメータ
  def order_params
    params.require(:order).permit(:customer_id, :order_detail_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
  end
end
