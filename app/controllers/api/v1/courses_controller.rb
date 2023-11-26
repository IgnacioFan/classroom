class Api::V1::CoursesController < ApplicationController
  before_action :course_params, only: %i[create update] 
  before_action :find_course, only: %i[show update]

  def index
    @courses = Course.includes(chapters: :units).paginate(page: params[:page], per_page: per_page)
    render formats: [:json]
  end

  def create
    ok, message = validate_params_on_create
    return bad_request(message) if !ok 
    
    if CourseFactory.new(course_params).execute
      render json: { message: "Created the course, relevant chapters, and units" }, status: :ok 
    end
  end

  def show
    render formats: [:json]
  end

  def update
    ok, message = validate_params_on_update
    return bad_request(message) if !ok 
    
    if CourseUpdater.new(@course, course_params).execute
      render json: { message: "Updated the course, relevant chapters, and units" }, status: :ok 
    end
  end

  def destroy
    @course = Course.find(course_id)
    if @course.destroy!
      render json: { message: "Deleted the course, relevant chapters, and units" }, status: :ok 
    end
  end

  private

  def per_page
    return 30 if params[:number].to_i >= 30
    params[:number] || 15
  end

  def course_id
    params[:id].to_i
  end

  def validate_params_on_create
    CourseParamsValidator.new(course_params)
      .validate_course_required
      .validate_chapters_and_units_presence
      .full_message
  end

  def validate_params_on_update
    CourseParamsValidator.new(course_params)
      .validate_course_required
      .validate_chapters_and_units_missed(@course)
      .full_message
  end

  def find_course
    @course = Course.includes(chapters: :units).find(course_id)
  end

  def course_params
    params
      .require(:course)
      .permit(
        :id,
        :name,
        :description,
        :lecturer,
        chapters: [
          :id,
          :name,
          :_deleted,
          units: [
            :id,
            :name,
            :description,
            :content,
            :_deleted,
          ]
        ]
      )
  end
end
