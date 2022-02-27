class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  # 閲覧数　いらない
  # impressionist :actions => [:show]

  def show
    @book_comment = BookComment.new
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    # @bookに対応するユーザーを持ってくる　@user = @book.user（アソシエーションのuser)
    # @book_comments = @book.book_comments
    # book_commentはアソシエーションhas_many book_commentのこと

    # 閲覧数
    impressionist(@book, nil, unique: [:session_hash])
  end

  def index
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    # Book.newは空の変数で(book_params)はtitleとbodyが入っている。
    @book.user_id = current_user.id
    # currnt_user.idはカレントユーザーのidの意味
    # @book.user_idは@bookのユーザーid
    # _は単語の区切り
    # .はカラムの情報を取ってくる。要素(user_id)の
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  # 他人のユーザー画面に遷移できないようにする。
  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to books_path unless @user == current_user
  end
end
