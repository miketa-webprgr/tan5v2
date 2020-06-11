class TangoDatum < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :wordnote, class_name: "Wordnote", foreign_key: "wordnote_id"
  belongs_to :tango, class_name: "Tango", foreign_key: "tango_id"
end
