class Course < ApplicationRecord
  belongs_to :style, required: true, inverse_of: :courses
  has_many :lessons, inverse_of: :course
  has_and_belongs_to_many :teachers

  validates_presence_of :name, :start_date, :track_payrolls
end
