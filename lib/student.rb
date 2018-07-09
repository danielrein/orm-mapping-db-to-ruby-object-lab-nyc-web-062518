require 'pry'

class Student
  attr_accessor :id, :name, :grade

   def run_sql(string, *args)
    DB[:conn].execute(string, *args)
  end

  def self.run_sql(string, *args)
    DB[:conn].execute(string, *args)
  end

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    run_sql('SELECT * FROM students').map do |row|
      self.new_from_db
    end
  end

  def self.find_by_name(name)
    array = run_sql('SELECT * FROM students WHERE name = ? LIMIT 1', name)
    array.map { |row| self.new_from_db(row) }.first
  end

  def self.count_all_students_in_grade_9
    run_sql('SELECT * FROM students WHERE grade = ?', 9)
  end

  def self.students_below_12th_grade
    run_sql('SELECT * FROM students WHERE grade < ?', 12).map { |row| self.new_from_db(row) }
  end

  def self.all
    run_sql('SELECT * FROM students').map { |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(x)
    run_sql('SELECT * FROM students WHERE grade = ? LIMIT ?', 10, x).map { |row| self.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    row = run_sql('SELECT * FROM students WHERE grade = ? LIMIT ?', 10, 1)[0]
    self.new_from_db(row)
    # binding.pry
  end

  def self.all_students_in_grade_X(x)
    run_sql('SELECT * FROM students WHERE grade = ?', x)
  end

  def save
      run_sql('INSERT INTO students (name, grade)
      VALUES (?, ?)', self.name, self.grade)
  end

  def self.create_table
    run_sql('CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, name TEXT, grade TEXT)')
  end

  def self.drop_table
    run_sql('DROP TABLE IF EXISTS students')
  end


end

yosi = Student.new_from_db([1, "joe", 9]);
# Student.find_by_name('joe')
# binding.pry
