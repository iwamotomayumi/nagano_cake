class Public::AddressesController < ApplicationController
  def index
    @address = Address.new
    @customer = current_customer
    @addresses = @customer.addresses
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      flash[:notice] = "新規登録しました"
      redirect_to addresses_path
    else
      flash[:notice] = "必要事項を入力して下さい"
      render :index
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
    flash[:notice] = "変更を保存しました"
    redirect_to addresses_path
    else
       flash[:notice] = "変更内容を入力して下さい"
      render :edit
    end
  end

  private
  # ストロングパラメータ
  def address_params
    params.require(:address).permit(:order_id, :customer_id, :name, :postal_code, :address)
  end

end
