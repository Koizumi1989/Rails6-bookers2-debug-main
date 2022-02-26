class Chat < ApplicationRecord
  
  # チャット機能
  belongs_to :user
  belongs_to :room
end
