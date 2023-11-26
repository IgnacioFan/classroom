class CourseParamsValidator

  attr_reader :course_params
  attr_accessor :errors

  def initialize(params)
    @course_params = params
    @errors = []
  end

  def full_message
    errors.any? ? [false, errors.join("\n")] : [true, ""]
  end

  def validate_course_required
    errors << "Name and lecture cannot be blank" if course_params[:name].blank? || course_params[:lecturer].blank?

    course_params[:chapters]&.each do |chapter|
      if chapter[:name].blank?
        errors << "Each chapter must have a name" 
        break
      end

      chapter[:units]&.each do |unit|
        if unit[:name].blank? || unit[:content].blank?
          errors << "Each unit must have name and content" 
          break
        end
      end
    end

    self
  end

  def validate_chapters_and_units_presence
    errors << "Chapters and units must include when create" if course_params[:chapters].blank? 

    course_params[:chapters].each do |chapter|
      if chapter[:units].blank?
        errors << "Chapters and units must include when create" 
        break
      end
    end

    self
  end

  def validate_chapters_and_units_missed(course)
    chapter_set = Set.new
    unit_set = Set.new
    
    course.chapters.each do |chapter|
      chapter_set << chapter.id
      chapter.units.each do |unit|
        unit_set << unit.id
      end
    end

    course_params[:chapters]&.each do |chapter_params|
      chapter_set.delete(chapter_params[:id])

      chapter_params[:units]&.each do |unit_params|
        unit_set.delete(unit_params[:id])
      end
    end
    
    if !chapter_set.empty?
      errors << "Chapter Id (#{chapter_set.join(", ")}) must include" 
    end

    if !unit_set.empty?
      errors << "Unit Id (#{unit_set.join(", ")}) must include" 
    end

    self
  end
end
