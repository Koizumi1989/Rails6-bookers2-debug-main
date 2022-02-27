class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  # userは、group_usersという中間テーブルを通じてgroupsにアクセスできるという記述
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image

  # チャット機能
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy


  # フォローをした、されたの関係
  # class_name:関連名と参照元のクラス名を異なるものにしたい場合につかう。
  # foreign_key:参照元のテーブルに定義されている外部キーの名前を指定
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  # 下記の意味followingsは中間テーブルrelationshipsを経由して、follwedを参照している。
  # through:結合モデルの指定
  # source:	has_many :through の元となるオブジェクトを指定
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 逆になる？

  # ゲストログイン
  # ◆find_or_create_byとは？
  # find_or_create_byは、データの検索と作成を自動的に判断して処理を行う、Railsのメソッドです。
  # 具体的には、find_or_create_by(条件)の条件としたデータが存在するかどうかを判断した上で
  # ・存在する場合には、そのデータを返す
  # ・存在しない場合は、新規作成する
  # という判断と処理を行います。
  # また、find_or_create_by!の「!」を付与することで、処理がうまくいかなかった場合にエラーが発生するようになり、結果不具合を検知しやすくなります。
  # SecureRandom.urlsafe_base64とは？
  # SecureRandom.urlsafe_base64は、ランダムな文字列を生成するRubyのメソッドの一種です。

  # パスワードはSecureRandom.urlsafe_base64でランダムな文字列にすることができます。
  # またnameは"guestuser"と固定しています。
  def self.guest
    find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  # ()ないの意味はここで自分で指定しているだけ
  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # 検索方法分岐
  # 送られてきたsearchによって条件分岐させましょう。
  # あいまい検索　whereでdbから該当データ取得
  # モデルクラス.where("列名 LIKE ?", "%値%")  値(文字列)を含む
  # モデルクラス.where("列名 LIKE ?", "値_")   値(文字列)と末尾の1文字

  def self.looks(search, word)
    # 完全一致→perfect_match
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
      # 前方一致→forward_match
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
      # 後方一致→backword_match
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
      # 部分一致→partial_match
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    profile_image.attached? ? profile_image : 'no_image.jpg'
  end
end
