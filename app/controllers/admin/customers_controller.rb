class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
    flash[:notice] = "変更を保存しました"
    redirect_to admin_customer_path(@customer.id)
    else
      flash[:notice] = "変更内容を入力して下さい"
      render :edit
    end
  end


   private
  # ストロングパラメータ
  def customer_params
    params.require(:customer).permit(:last_name, :first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:telephone_number,:is_deleted,:email,)
  end

end
