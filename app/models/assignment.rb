class Assignment < ActiveRecord::Base
  validates :geography, presence: true
  validates :volunteer, presence: true
  belongs_to :volunteer
  belongs_to :geography
end
