class Book < ApplicationRecord
  belongs_to:user
  has_many:favorites,dependent: :destroy
  has_many:book_comments,dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}

  # 下記は一人一回のいいねしかできない。
  def favorited_by?(user)
    # (user)は上のbelongs_to userのこと。
    favorites.exists?(user_id: user.id)
    # favoritesが存在しているかどうか(favoriteテーブルのユーザーIDがuser.idと一致するか)
    # favoriteモデルのuser_idとuser(上のuser).id
  end
  # 本がそのユーザーからいいねされているか確かめるメソッドがfavorite_by、そのため、book.rbのみに記載。
end
