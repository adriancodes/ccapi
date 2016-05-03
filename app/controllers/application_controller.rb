class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    def index
        # Root resource that emits json data containing basic information about this exercise
        render json: {:company => "Care Cloud",
                      :candidate => "Adrian Martin",
                      :position => "Senior Software Engineer",
                      :exercise => "Appointment API"}
    end

    def error_not_found!
      # Catch-all route error handler for the application. Will return method not allowed status code.
        render json: {:error => {:message => "Request Method Not Allowed"}}.to_json, status: :method_not_allowed
    end
end
