class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    def error_not_found!
        render json: {:error => {:message => "Request Method Not Allowed"}}.to_json, status: 405
    end
end
