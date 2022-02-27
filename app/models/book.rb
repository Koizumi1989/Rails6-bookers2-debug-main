class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :book

  has_many :book_comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  # 閲覧数
  is_impressionable counter_cache: true

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_3day, -> { where(created_at: 2.day.ago.all_day) } # 3日前
  scope :created_4day, -> { where(created_at: 3.day.ago.all_day) } # 4日前
  scope :created_5day, -> { where(created_at: 4.day.ago.all_day) } # 5日前
  scope :created_6day, -> { where(created_at: 5.day.ago.all_day) } # 6日前
  scope :created_thisweek, -> { where(created_at: 1.week.ago.beginning_of_day..Time.zone.now.end_of_day) } # 今週
  scope :created_lastweek, -> { where(created_at: 1.week.ago.all_day) } # 先週

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
