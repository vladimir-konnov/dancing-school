class Style < ApplicationRecord
  has_many :courses, inverse_of: :style, dependent: :restrict_with_exception

  validates_presence_of :name, :duration_hours
  validates_uniqueness_of :name
end
