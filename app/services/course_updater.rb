class CourseUpdater

  attr_accessor :course, :course_params
  
  def initialize(id, params)
    @course = Course.preload(chapters: :units).find(id)
    @course_params = params
  end

  def execute
    ActiveRecord::Base.transaction do 
      map_course_info
      course.save!
    end
  end

  private

  def map_course_info
    course.assign_attributes(
      name: course_params[:name],
      lecturer: course_params[:lecturer],
      description: course_params[:description]
    )
    
    chapter_index = 0

    course_params[:chapters].each do |chapter_params|
      chapter = course&.chapters&.find { |c| c.id == chapter_params[:id] } 
      if chapter.nil?
        chapter = course.chapters.create(
          name: chapter_params[:name],
          sort_key: chapter_index
        )
      elsif chapter && chapter_params[:_deleted].present?
        chapter.destroy!
        next
      else
        Chapter.where(id: chapter_params[:id]).update_all(
          name: chapter_params[:name],
          sort_key: chapter_index
        )
      end
      
      unit_index = 0
      chapter_params[:units].each do |unit_params|
        unit = chapter&.units.find { |u| u.id == unit_params[:id] } 
        if unit.nil?
          chapter.units.create(
            name: unit_params[:name],
            description: unit_params[:description],
            content: unit_params[:content],
            sort_key: unit_index
          )
        elsif unit && unit_params[:_deleted].present?
          unit.destroy!
          next
        else
          Unit.where(id: unit_params[:id]).update_all(
            name: unit_params[:name],
            description: unit_params[:description],
            content: unit_params[:content],
            sort_key: unit_index
          )
        end

        unit_index += 1
      end

      chapter_index += 1
    end
  end
end
