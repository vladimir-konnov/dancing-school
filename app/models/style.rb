class Style < ApplicationRecord
  has_many :lessons, inverse_of: :style, dependent: :restrict_with_exception
  has_and_belongs_to_many :teachers, class_name: 'User', association_foreign_key: :user_id, inverse_of: :styles

  validates_presence_of :name, :duration_hours
  validates_uniqueness_of :name
  validates_inclusion_of :calculate_payrolls, :party_subscription, in: [true, false]
end
