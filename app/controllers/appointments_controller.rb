class AppointmentsController < ApplicationController
    before_action :get_data, only: [:list, :update, :delete]
    rescue_from ::ActionController::RoutingError, with: :error_not_found!
    rescue_from ::ActiveRecord::RecordNotFound, with: :error_not_found!
    rescue_from ::ActionController::ParameterMissing, with: :error_params!
    rescue_from ::NameError, with: :error_generic!
    rescue_from ::SyntaxError, with: :error_generic!

    def list
        render json: @data
    end

    def create
        @data = Appointment.create(appointment_params)
        if @data.save
            render json: @data, location: @data, status: :created
        else
            render json: {:error => {:message => @data.errors}}.to_json, status: :unprocessable_entity
        end
    end

    def update
        if @data.update_attributes(appointment_params)
            render json: {}, status: :no_content
        else
            render json: {:error => {:message => @data.errors}}.to_json, status: :unprocessable_entity
        end
    end

    def delete
         render json: @data.destroy, status: :no_content
    end

    protected

    def get_data
        if params[:id]
            @data = Appointment.find(params[:id])
        else
            @data = Appointment.all
        end
    end

    def appointment_params
        params.require(:appointment).permit(:first_name, :last_name, :start_time, :end_time, :comment)
    end

    def appointment_url(data)
        @data.id.to_s
    end

    def error_generic!(exception)
        render json: {:error => {:message => exception.message}}.to_json, status: :internal_server_error
    end

    def error_params!(exception)
        render json: {:error => {:message => exception.message}}.to_json, status: :bad_request
    end

    def error_not_found!(exception)
        render json: {:error => {:message => exception.message}}.to_json, status: :not_found
    end
end
