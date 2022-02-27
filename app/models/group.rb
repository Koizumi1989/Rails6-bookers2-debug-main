class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :image_id

  def get_image_id
    image_id.attached? ? image_id : 'no_image.jpg'
  end
end
