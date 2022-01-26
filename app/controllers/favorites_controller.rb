class FavoritesController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    # ここでひつようなのbook_idとuser_idが必要。favoriteテーブルの中のカラム。
    # favorite = current_user.favorites.new(book_id: book.id)と下記記述は同じ内容
    favorite = Favorite.new(book_id:book.id,user_id:current_user.id)
    # (左側はカラムの名前：右が代入する値（book=Book.find(params[:book_id])のこと)
    # (左側はカラムの名前：右が代入する値（current_user.id)のこと)
    favorite.save
    redirect_to request.referer
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    redirect_to request.referer
  end

end
