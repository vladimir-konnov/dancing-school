class Teacher < ApplicationRecord
  has_and_belongs_to_many :styles

  validates_presence_of :firstname, :lastname
  validates_inclusion_of :banned, in: [true, false]
end
