class Api::V1::CoursesController < ApplicationController
  
  def index
    @courses = Course.includes(chapters: :units)
    @courses = @courses.paginate(page: params[:page], per_page: per_page)
    render formats: [:json]
  end

  def create
    # valdate course_params
    if CourseFactory.new(course_params).execute
      render json: { message: "Created the course, relevant chapters, and units" }, status: :ok 
    end
  end

  def show
    @course = Course.includes(chapters: :units).find(params["id"])
    render formats: [:json]
  end

  def update
    # valdate course_params
    updater = CourseUpdater.new
    if updater.execute(params[:id], course_params)
      render json: { message: "Updated the course, relevant chapters, and units" }, status: :ok 
    end
  end

  def destroy
    @course = Course.find(params[:id])
    if @course.destroy!
      render json: { message: "Deleted the course, relevant chapters, and units" }, status: :ok 
    end
  end

  private

  def per_page
    return 30 if params[:number].to_i >= 30
    params[:number] || 15
  end

  def course_params
    params
      .require(:course)
      .permit(
        :name,
        :description,
        :lecturer,
        chapters: [
          :id,
          :name,
          :sort_key,
          units: [
            :id,
            :name,
            :description,
            :content,
            :sort_key,
          ]
        ]
      )
  end
end
