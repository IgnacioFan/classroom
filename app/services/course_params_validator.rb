class CourseParamsValidator
  
  def initialize(params, action)
    @course_params = params
    @action = action
    @errors = []
  end

  def valid?
    validate_course_required
    validate_chapters_and_units_presence

    @errors.any? ? [false, @errors.join("\n")] : [true, ""]
  end

  private

  def validate_course_required
    @errors << "Name and lecture cannot be blank" if @course_params[:name].blank? || @course_params[:lecturer].blank?

    @course_params[:chapters]&.each do |chapter|
      if chapter[:name].blank?
        @errors << "Each chapter must have a name" 
        return
      end

      chapter[:units]&.each do |unit|
        if unit[:name].blank? || unit[:content].blank?
          @errors << "Each unit must have name and content" 
          return
        end
      end
    end
  end

  def validate_chapters_and_units_presence
    return if @action == "update"
    if @course_params[:chapters].blank? 
      @errors << "Chapters and units must include when create" 
      return
    end

    @course_params[:chapters].each do |chapter|
      if chapter[:units].blank?
        @errors << "Chapters and units must include when create" 
        return
      end
    end
  end
end
