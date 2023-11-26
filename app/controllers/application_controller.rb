class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  private

  def bad_request(message)
    render json: { error: message }, status: :bad_request 
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end
end
