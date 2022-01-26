class Book < ApplicationRecord
  belongs_to:user
  has_many:favorites,dependent: :destroy
  has_many:book_comments,dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
    # favoriteモデルのuser_idとuser(上のuser).id
  end
  # 本がそのユーザーからいいねされているか確かめるメソッドがfavorite_by、そのため、book.rbのみに記載。
end
