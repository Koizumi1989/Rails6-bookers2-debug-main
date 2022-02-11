class SearchesController < ApplicationController
  before_action :authenticate_user!
  # ログインしていないと使用できないからbefore_action設定

  #   下記コードにて検索フォーム(_search.html.erb)からの情報を受け取っています。
  # 　検索モデル→params[:range]
  # 　検索方法→params[:search]
  # 　検索ワード→params[:word]

  def search_result
    @word = params[:word]

    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
      # if文を使い、検索モデルUserorBookで条件分岐させます。
      # looksメソッドを使い、検索内容を取得し、変数に代入します。
      # 検索方法params[:search]と、検索ワードparams[:word]を参照してデータを検索し、
      # インスタンス変数@usersにUserモデル内での検索結果を代入します。
      # インスタンス変数@booksにBookモデル内での検索結果を代入します。
    end
  end
end
