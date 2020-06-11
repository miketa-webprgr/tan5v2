class Tango < ApplicationRecord
  self.inheritance_column = nil
  
  belongs_to :wordnote, class_name: "Wordnote", foreign_key: "wordnote_id"
  has_many :tango_datum, class_name: "TangoDatum", dependent: :destroy
end
