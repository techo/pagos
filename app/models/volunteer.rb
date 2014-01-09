class Volunteer < User
  has_many :assignments
  has_many :geographies, through: :assignments

  default_scope { where(role:"voluntario").order("first_name ASC")}
end
