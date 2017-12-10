class ReferenceTables < ActiveRecord::Migration[5.1]
  def change
    create_table :teachers do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :middlename
      t.boolean :banned, null: false, default: false
      t.text :comment
      t.timestamps

      #t.index [:firstname, :lastname, :middlename], unique: true
    end

    create_table :styles do |t|
      t.string :name, null: false
      t.decimal :duration_hours, null: false, default: 1, precision: 4, scale: 2
      t.timestamps

      t.index :name, unique: true
    end

    create_table :subscription_types do |t|
      t.string :name, null: false
      t.integer :number_of_lessons, null: false, default: 1
      t.decimal :cost, null: false, default: 300, precision: 8, scale: 2
      t.timestamps
    end

    create_table :students do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :middlename
      t.string :phone_number
      t.string :email
      t.string :vk_profile
      t.text :comment
      t.timestamps
    end

    create_table :subscriptions do |t|
      t.string :name, null: false
      t.references :subscription_type, null: false, index: true
      t.references :student, null: false, index: true
      t.date :purchase_date, null: false
      # when expiry_date is null, then the subscription is infinite
      t.date :expiry_date
      t.decimal :price, null: false, precision: 8, scale: 2
      t.references :paired_with, index: true
      t.boolean :finished, null: false, default: false, index: true

      t.timestamps
    end
    add_foreign_key :subscriptions, :subscription_types
    add_foreign_key :subscriptions, :students
    add_foreign_key :subscriptions, :subscriptions, column: :paired_with_id

    create_table :courses do |t|
      t.string :name, null: false
      t.references :style, null: false, index: true
      t.date :start_date, null: false
      # if end date is null then the course is eternal
      t.date :end_date
      t.boolean :track_payrolls, null: false, default: true
      t.timestamps
    end
    add_foreign_key :courses, :styles

    create_join_table :courses, :teachers do |t|
      t.index :course_id
      t.index :teacher_id
      t.index [:course_id, :teacher_id], unique: true
      t.timestamps
    end
    add_foreign_key :courses_teachers, :courses
    add_foreign_key :courses_teachers, :teachers

    create_table :lessons do |t|
      t.references :course, null: false, index: true
      t.date :date
    end
    add_foreign_key :lessons, :courses

    create_join_table :lessons, :students do |t|
      t.index :lesson_id
      t.index :student_id
      # if subscription is missing then student attended without subscription
      t.references :subscription, index: true
      t.timestamps

      t.index [:lesson_id, :student_id], unique: true
      t.index [:lesson_id, :student_id, :subscription_id], name: 'index_lessons_students_subscriptions'
    end
    add_foreign_key :lessons_students, :lessons
    add_foreign_key :lessons_students, :students
    add_foreign_key :lessons_students, :subscriptions
  end
end
