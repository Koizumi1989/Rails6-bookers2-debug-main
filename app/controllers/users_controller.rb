class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  # ゲストユーザー　コントローラーeditアクションが実行される前の処理
  before_action :ensure_guest_user, only: [:edit]

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    @books_user =@user.books
    # 投稿者数関連
    @today_book = @books_user.created_today
    @yesterday_book = @books_user.created_yesterday
    @book_2day = @books_user.created_2day
    @book_3day = @books_user.created_3day
    @book_4day = @books_user.created_4day
    @book_5day = @books_user.created_5day
    @book_6day = @books_user.created_6day
    @thisweek_book = @books_user.created_thisweek
    @lastweek_book = @books_user.created_lastweek
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where("created_at LIKE?", "#{create_at}%").count
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render 'users/edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  # ゲストユーザー ユーザーの編集画面のurlを直接打たれた時の対応。
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
