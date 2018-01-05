class User < ApplicationRecord
  ADMIN_USER_EMAIL = 'admin@dandance.com'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  has_many :subscriptions_created, class_name: 'Subscription', inverse_of: :user
  has_and_belongs_to_many :roles, class_name: 'Role', inverse_of: :users, join_table: :users_roles
  has_and_belongs_to_many :lessons, inverse_of: :teachers, foreign_key: :user_id
  has_and_belongs_to_many :styles, class_name: 'Style', inverse_of: :teachers

  after_create { |user| user.roles << Role.teacher }

  validates_presence_of :firstname, :lastname
  validates_inclusion_of :banned, in: [true, false]

  scope :ordinary_users, -> { where.not(email: ADMIN_USER_EMAIL) }

  def name
    "#{firstname} #{lastname}"
  end

  def admin?
    has_role?('admin')
  end

  def teacher?
    has_role?('teacher') || admin?
  end

  def has_role?(role)
    roles.exists?(name: role)
  end

  def administrator_user?
    email == ADMIN_USER_EMAIL
  end
end
