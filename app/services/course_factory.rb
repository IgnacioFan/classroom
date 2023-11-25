class CourseFactory
  attr_reader :course_params

  def initialize(params)
    @course_params = params
  end

  def execute
    course = Course.build(
      name: course_params[:name],
      lecturer: course_params[:lecturer],
      description: course_params[:description]
    )
    
    course_params[:chapters].each do |chapter_params|
      build_chapter(course, chapter_params)
    end

    course.save!
  end

  private

  def build_chapter(course, chapter_params)
    chapter = course.chapters.build
    chapter.name = chapter_params[:name]
    chapter.sort_key = chapter_params[:sort_key]

    chapter_params[:units].each do |unit_params|
      build_unit(chapter, unit_params)
    end
  end

  def build_unit(chapter, unit_params)
    unit = chapter.units.build
    unit.name = unit_params[:name]
    unit.description = unit_params[:description]
    unit.content = unit_params[:content]
    unit.sort_key = unit_params[:sort_key]
  end
end
