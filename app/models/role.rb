class Role < ApplicationRecord
  has_and_belongs_to_many :users, class_name: 'User', inverse_of: :roles, join_table: :users_roles

  validates :name, presence: true, uniqueness: true

  def self.teacher
    Role.find_by_name :teacher
  end

  def self.admin
    Role.find_by_name :admin
  end
end
