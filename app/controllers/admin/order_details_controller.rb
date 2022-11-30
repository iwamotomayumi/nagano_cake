class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

  def update
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.update(order_detail_params)
    @order = @order_detail.order

        #注文商品の製作ステータスが“製作中:2“になったら、注文ステータスを“製作中:2“に更新
    if @order_detail.making_status_i18n == "製作中"
       @order.update(status: 2)
      flash[:notice] = "制作ステータスの更新しました。"
      @order.save
    end

    # 注文個数と制作完了になっている個数が同じならば
    if @order.order_details.count == @order.order_details.where(making_status: 3).count
      @order.update(status: 3)
      flash[:notice] = "制作ステータスの更新しました。"
      @order.save
    end

        redirect_to admin_order_path(@order)
  end

  def order_detail_params
    params.require(:order_detail).permit(:item_id, :order_id, :price, :amount, :making_status)
  end

end
