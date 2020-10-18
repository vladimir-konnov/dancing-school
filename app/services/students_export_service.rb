require 'csv'

class StudentsExportService
  FIELDS_TO_EXPORT = [
    :firstname, :lastname, :middlename, :phone_number, :email,
    :vk_profile, :comment, :created_at, :birthday
  ]

  def export_students(students)
    CSV.generate do |csv|
      csv << column_names # header row
      students.each { |student| csv << student_row(student) } # add a row for each student
    end
  end

  private

  def column_names
    FIELDS_TO_EXPORT.map { |column_name| I18n.t "students.export.column_names.#{column_name}" }
  end

  def student_row(student)
    FIELDS_TO_EXPORT.map do |field|
      value = student.public_send(field)
      value.is_a?(Time) ? value.to_date : value
    end
  end
end
