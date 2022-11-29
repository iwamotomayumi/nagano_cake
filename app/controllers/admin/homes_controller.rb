class Admin::HomesController < ApplicationController
  def top
    @orders = Order.page(params[:page])
    @order_detail = OrderDetail.page(params[:page])

  end

   private
  # ストロングパラメータ
  def order_params
    params.require(:order).permit(:customer_id, :order_detail_id, :postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method, :status)
  end

end