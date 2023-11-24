class Api::V1::CoursesController < ApplicationController
  def index
    render formats: [:json]
  end

  def create
    # valdate course_params
    factory = CourseFactory.new.with_params(course_params)
    if factory.execute
      render json: { message: "Successfully create course, chapters, and units" }, status: :ok 
    end
  end

  def show
    @course = Course.preload(chapters: :units).find(params["id"])
    render formats: [:json]
  end

  def update
    render formats: [:json]
  end

  def destroy
    render formats: [:json]
  end

  private

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
