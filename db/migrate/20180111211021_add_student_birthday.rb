class AddStudentBirthday < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :birthday, :date
  end
end
