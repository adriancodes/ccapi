class Appointment < ActiveRecord::Base
    validates :first_name, :last_name, :start_time, :end_time, presence: true
end