class DeleteCourseTable < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :courses, :teachers
    remove_column :lessons, :course_id
    drop_table :courses

    add_column :lessons, :style_id, :integer, null: false, index: true
    add_foreign_key :lessons, :styles
    
    create_join_table :lessons, :teachers do |t|
      t.index :lesson_id
      t.index :teacher_id
      t.index [:lesson_id, :teacher_id], unique: true
      t.timestamps
    end
    add_foreign_key :lessons_teachers, :lessons
    add_foreign_key :lessons_teachers, :teachers
  end
end
