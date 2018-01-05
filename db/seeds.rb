# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# admin role
Role.create(name: 'admin') unless Role.exists?(name: 'admin')
# teacher role
Role.create(name: 'teacher') unless Role.exists?(name: 'teacher')

admin_email = User::ADMIN_USER_EMAIL
admin_user = User.find_by_email admin_email
if admin_user.nil?
  admin_password = ENV['ADMIN_PASSWORD']
  if admin_password.present?
    admin_user = User.new(email: admin_email,
                     firstname: 'admin',
                     middlename: 'of',
                     lastname: 'dandance',
                     password: admin_password,
                     password_confirmation: admin_password)
    admin_user.skip_confirmation!
    puts admin_user.errors.full_messages unless admin_user.save
  end
end

admin_user.roles << Role.admin if admin_user.present? && !admin_user.admin?
