class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :wordnote
  validates :user_id, presence: true
  validates :wordnote_id, presence: true
end
