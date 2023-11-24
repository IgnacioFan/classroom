class CourseFactory
  attr_reader :course

  def initialize
    @course = Course.build
  end

  def with_params(course_params)
    @course = Course.build
    @course.name = course_params[:name]
    @course.lecturer = course_params[:lecturer]
    @course.description = course_params[:description]

    course_params[:chapters].each do |chapter_params|
      build_chapter(course, chapter_params)
    end

    self
  end

  def execute
    @course.save!
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
