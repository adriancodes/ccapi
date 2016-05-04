class AppointmentsController < ApplicationController
    # Appointment API controller
    # Actions handled param initialization.
    # Enforces content type
    # Exception Rescue methods gracefully handled exceptions by converting them to
    # json responses with correct status codes
    before_filter :enforce_content_type
    before_action :get_data, only: [:list, :update, :delete]
    before_action :check_for_dates, only: [:list]
    rescue_from ::ActionController::RoutingError, with: :error_not_found!
    rescue_from ::ActiveRecord::RecordNotFound, with: :error_not_found!
    rescue_from ::ActionController::ParameterMissing, with: :error_params!
    rescue_from ::NameError, with: :error_generic!
    rescue_from ::SyntaxError, with: :error_generic!
    rescue_from ::ArgumentError, with: :error_params!

    def list
        # This action will list a single or all appointments (filtered or not)
        render json: @data
    end

    def create
        # This action will create a new resource and return the location is the save was successfull
        # and the data passes all validation filters
        @data = Appointment.create(appointment_params)
        if @data.save
            render json: @data, location: @data, status: :created
        else
            render json: {:error => {:message => @data.errors}}.to_json, status: :unprocessable_entity
        end
    end

    def update
        # This action will update the resource if the data passes all validation filters
        if @data.update_attributes(appointment_params)
            render json: {}, status: :no_content
        else
            render json: {:error => {:message => @data.errors}}.to_json, status: :unprocessable_entity
        end
    end

    def delete
        # This action will delete a resource
        render json: @data.destroy, status: :no_content
    end

    protected

    def get_data
        # Before action method that returns appointment resources depending on the parameters
        if params[:id]
            @data = Appointment.find(params[:id])
        elsif params["start_time"].present? && params["end_time"].present?
            @data = Appointment.filter(appointment_params)
        else
            @data = Appointment.all
        end
    end

    def check_for_dates
        # Checks if both dates are present if one of them is present
        if !params[:id].present?
          if  params[:start_time].present? && !params[:end_time].present?
            raise ActionController::ParameterMissing.new("Missing end time")
          elsif !params[:start_time].present? && params[:end_time].present?
            raise ActionController::ParameterMissing.new("Missing start time")
          end
        end
    end

    def parse_date(datestr)
      DateTime.strptime(datestr, "%m/%d/%y %H:%M").to_s(:db)
    end

    def appointment_params
        # Enforce the appropriate parameters from the request.
        # Also transforms the user-submitted dates to datetime from if they are present
        # The start_time and end_time format arrive as follows: "m/d/y h:m" (ie "11/5/14 7:05")
        # This is from the API spec but internally lets use some nice datetimes.
        if params["start_time"].present? && params["end_time"].present?
            params["start_time"] = parse_date(params["start_time"])
            params["end_time"] = parse_date(params["end_time"])
            if params["appointment"].present?
              params["appointment"]["start_time"] = params["start_time"]
              params["appointment"]["end_time"] = params["end_time"]
            end
        end
        params.permit(:first_name, :last_name, :start_time, :end_time, :comment, :appointment)
    end

    def appointment_url(data)
        # Helper function to properly form a location url
        @data.id.to_s
    end

    def enforce_content_type
      unless request.content_type == Mime::JSON.to_s || request.accepts.include?(Mime::JSON)
        render json: {:error => {:message => 'Content-Type must be application/json'}}, status: :not_acceptable
      end
    end

    def error_generic!(exception)
        # Generic exception handler. Returns json data with error and correct status code
        render json: {:error => {:message => exception.message}}.to_json, status: :internal_server_error
    end

    def error_params!(exception)
        # Parameter error exception handler. Returns json data with error and correct status code
        render json: {:error => {:message => exception.message}}.to_json, status: :bad_request
    end

    def error_not_found!(exception)
        # Not found exception handler. Returns json data with error and correct status code
        render json: {:error => {:message => exception.message}}.to_json, status: :not_found
    end
end
