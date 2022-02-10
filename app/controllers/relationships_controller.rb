class RelationshipsController < ApplicationController

  # paramsはurlのidをとってくる。relationshipsのcreateのurlは
  # POST /users/:user_id/relationships(.:format)となっており、
  # paramsで取得するidはuser_idとなる。
  # なぜidではなくuser_idになっているのか？ネストしているから。
  # ここでidとしてしまうとrelationship/controller内なので
  # relationshipのidが取れてしまう。まぎらわしくないよう
  # railsがpostのidをuser_idにしてくれている。
  #フォローする時
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  #フォローを外す時
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  #フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  #フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
