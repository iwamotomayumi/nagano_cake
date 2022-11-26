class Public::CustomersController < ApplicationController
  def show
    @customer = Customer.find(current_customer[:id])
  end

  def edit
    @customer = Customer.find(current_customer[:id])
  end

  def update
    @customer = Customer.find(current_customer[:id])
    if @customer.update(customer_params)
    flash[:notice] = "変更を保存しました"
    redirect_to customer_path(current_customer[:id])
    else
       flash[:notice] = "変更内容を入力して下さい"
      render :edit
    end
  end

  def unsubscribe
  end

  def withdrawal
    @customer = Customer.find(current_customer[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

   private
  # ストロングパラメータ
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :encrypted_password, :postal_code, :address, :telephone_number, :is_deleted)
  end


end
