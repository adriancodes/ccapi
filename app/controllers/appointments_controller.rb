class AppointmentsController < ApplicationController
    before_action :get_data, only: [:list, :update,:delete]
    rescue_from ::ActionController::RoutingError, with: :error_not_found!
    rescue_from ::ActiveRecord::RecordNotFound, with: :error_not_found!
    rescue_from ::NameError, with: :error_generic!
    rescue_from ::SyntaxError, with: :error_generic!

    def list
        render json: @data
    end

    def create
    end

    def update
    end

    def delete
         render json: @data.destroy, status: 204
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

    def error_generic!(exception)
        render json: {:error => {:message => exception.message}}.to_json, status: 500
    end

    def error_not_found!(exception)
        render json: {:error => {:message => exception.message}}.to_json, status: :not_found
    end
end
