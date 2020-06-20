class Wordnote < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :tangos, class_name: "Tango", dependent: :destroy
  has_many :tango_datum, class_name: "TangoDatum", dependent: :destroy
  has_many :tango_config, class_name: "TangoConfig", dependent: :destroy
  has_many :favorite, class_name: "Favorite", dependent: :destroy
end
