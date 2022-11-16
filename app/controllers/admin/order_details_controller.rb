class Admin::OrderDetailsController < ApplicationController
  def update
    @order_detail = Order_detail.find(params[:id])
  end

  def rder_detail_params
    params.require(:rder_detail).permit(:item_id, :order_id, :price, :amount, :making_status)
  end

end
