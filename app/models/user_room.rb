class UserRoom < ApplicationRecord
  # チャット機能
  # usersテーブルとroomsテーブルの中間テーブル
  belongs_to :user
  belongs_to :room
end
