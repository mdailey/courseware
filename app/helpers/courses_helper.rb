module CoursesHelper
  def sorted_names(people)
    people.sort {|i1,i2| i1.lastname <=> i2.lastname}.collect {|i| i.firstname + ' ' + i.lastname }.join(', ')
  end
  
  def sort_field(course)
    month =
      case course.semester
      when 'Summer' then 'June'
      else course.semester
      end
    Time.parse month + ' ' + course.year.to_s
  end
end
