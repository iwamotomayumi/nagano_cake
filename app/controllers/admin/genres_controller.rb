class Admin::GenresController < ApplicationController

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:notice] = "新規登録しました"
      redirect_to admin_genres_path
    else
      render :index
    end
  end

  def index
    @genres = Genre.all
    @genre = Genre.new
  end


  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
    flash[:notice] = "変更を保存しました"
    redirect_to admin_genres_path
    else
      render :edit
    end
  end

  private
  # ストロングパラメータ
  def genre_params
    params.require(:genre).permit(:name)
  end
end
