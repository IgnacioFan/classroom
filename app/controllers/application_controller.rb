class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :invalid_json_payload
  rescue_from ActionController::UnpermittedParameters, with: :unpermit_params
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  private

  def invalid_json_payload(exception)
    render json: { errors: [ exception.message ] }, status: :unprocessable_entity
  end

  def unpermit_params(exception)
    render json: { "Unpermitted Parameters found": exception.params }, status: :unprocessable_entity
  end

  def bad_request(message)
    render json: { error: message }, status: :bad_request 
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end
end
