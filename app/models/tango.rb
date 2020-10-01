class Tango < ApplicationRecord
  self.inheritance_column = nil
  
  belongs_to :wordnote, class_name: "Wordnote", foreign_key: "wordnote_id"
  has_many :tango_datum, class_name: "TangoDatum", dependent: :destroy

  scope :asc_with_datum, -> { order(id: :asc).includes(:tango_datum) }
  scope :desc_with_datum, -> { order(id: :desc).includes(:tango_datum) }
  scope :random_with_datum, -> { includes(:tango_datum).shuffle }
end
