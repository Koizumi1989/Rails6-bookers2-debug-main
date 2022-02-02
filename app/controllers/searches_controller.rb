class SearchesController < ApplicationController
  before_action :authenticate_user!
  #ログインしていないと使用できないからbefore_action設定

#   下記コードにて検索フォーム(_search.html.erb)からの情報を受け取っています。
# 　検索モデル→params[:range]
# 　検索方法→params[:search]
# 　検索ワード→params[:word]

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end
  end
end
