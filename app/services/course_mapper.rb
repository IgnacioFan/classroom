class CourseMapper
  def initialize
    @course = nil
    @new_chapters = []
    @new_units = []
    @old_chapters = {}
    @old_units = {}
  end

  def set_course(course)
    @course = course
  end

  def set_chapter(chapter_attrs, id)
    if id.nil?
      @new_chapters << chapter_attrs
    else
      @old_chapters[id] = chapter_attrs
    end
  end

  def set_unit(unit_attrs, id)
    if id.nil?
      @new_units << unit_attrs
    else
      @old_units[id] = unit_attrs
    end
  end

  def commit
    ActiveRecord::Base.transaction do 
      @old_chapters.each { |id, attrs| Chapter.where(id: id).update_all(attrs) }
      @old_units.each { |id, attrs| Unit.where(id: id).update_all(attrs) } 
      
      @new_chapters.each do |chapter_attrs|
        chapter = @course.chapters.build(chapter_attrs)
        
        @new_units.each do |unit_attrs|
          chapter.units.build(unit_attrs)  
        end
      end
      @course.save!
    end
  end
end
