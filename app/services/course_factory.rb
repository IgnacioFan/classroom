class CourseFactory
  attr_reader :course_params

  def initialize(params)
    @course_params = params
  end

  def execute
    course = build_course_info
    course.save!
  end

  private

  def build_course_info
    course = Course.build(
      name: course_params[:name],
      lecturer: course_params[:lecturer],
      description: course_params[:description]
    )

    course_params[:chapters].each_with_index do |chapter_params, chapter_index|
      chapter = course.chapters.build(
        name: chapter_params[:name],
        sort_key: chapter_index
      )
      
      chapter_params[:units].each_with_index do |unit_params, unit_index|
        chapter.units.build(
          name: unit_params[:name],
          description: unit_params[:description],
          content: unit_params[:content],
          sort_key: unit_index
        )
      end
    end

    course
  end
end
