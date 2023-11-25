class CourseUpdater
 
  def initialize(id, params)
    @course_id = id
    @course_params = params
    @course_mapper = CourseMapper.new
  end

  def execute
    course = Course.preload(chapters: :units).find(@course_id)
    course.name = @course_params[:name]
    course.lecturer = @course_params[:lecturer]
    course.description = @course_params[:description]

    @course_mapper.set_course(course)

    @course_params[:chapters].each do |chapter_params|
      update_chapter(course, chapter_params)
    end

    @course_mapper.commit
  end

  private

  def update_chapter(course, chapter_params)
    chapter = course&.chapters&.find { |chapter| chapter.id == chapter_params[:id] } 

    @course_mapper.set_chapter(
      {
        name: chapter_params[:name],
        sort_key: chapter_params[:sort_key]
      }, 
      chapter&.id
    )

    chapter_params[:units].each do |unit_params|
      update_unit(chapter, unit_params)
    end
  end

  def update_unit(chapter, unit_params)
    unit = chapter&.units&.find { |unit| unit.id == unit_params[:id] } 

    @course_mapper.set_unit(
      {
        name: unit_params[:name],
        description: unit_params[:description],
        content: unit_params[:content],
        sort_key: unit_params[:sort_key]
      },  
      unit&.id
    )
  end
end
