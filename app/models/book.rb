class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  # 下記は一人一回のいいねしかできない。
  def favorited_by?(user)
    # (user)は上のbelongs_to userのこと。
    favorites.exists?(user_id: user.id)
    # favoritesが存在しているかどうか(favoriteテーブルのユーザーIDがuser.idと一致するか)
    # favoriteモデルのuser_idとuser(上のuser).id
  end
  # 本がそのユーザーからいいねされているか確かめるメソッドがfavorite_by、そのため、book.rbのみに記載。
end
