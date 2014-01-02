class Geography < ActiveRecord::Base
  validates :village_id, presence: {message: "El identificador de asentamiento es mandatorio"}
  has_many :assignments
  has_many :volunteers, through: :assignments
end
