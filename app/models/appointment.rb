class Appointment < ActiveRecord::Base
    validates :first_name, :last_name, :start_time, :end_time, presence: true
    validate :start_and_end_times_are_blank, on: :create
    validate :start_and_end_times_are_blank, on: :update
    validate :start_and_end_date_are_in_the_past, on: :create
    validate :start_and_end_date_are_in_the_past, on: :update
    # validate :dates_are_overlapping, on: :create
    # validate :dates_are_overlapping, on: :update

    scope :overlapping, lambda { |start_time, end_time|

        p start_time
        p end_time
      {:conditions => [
         '(start_time BETWEEN ? AND ? OR end_time BETWEEN ? AND ?) OR (start_time <= ? AND end_time >= ?)',
         start_time, end_time, start_time, end_time, start_time, end_time
       ]}
    }

    def start_and_end_times_are_blank
        if !start_time.present? && !end_time.present?
            errors.add(:start_time, "Missing start time")
            errors.add(:end_time, "Missing end time")
        elsif !start_time.present?
            errors.add(:start_time, "Missing start time")
        elsif !end_time.present?
            errors.add(:end_time, "Missing end time")
        end
    end

    def start_and_end_date_are_in_the_past
        if start_time < Time.current
            errors.add(:start_time, "Time cannot be in the past")
        elsif end_time < Time.current
            errors.add(:end_time, "Time cannot be in the past")
        end
    end

    def dates_are_overlapping
        begin
            # data = Appointment.where("((start_time <= :start_time) && (end_time > :start_time)) || ((end_time > :end_time) && (start_time <= :end_time))", {:start_time => start_time, :end_time => end_time})
            # data = Appointment.where("(start_time BETWEEN :start_time AND :end_time OR end_time BETWEEN :start_time AND :end_time) OR (start_time <= :start_time AND end_time >= :end_time))", {:start_time => start_time,:end_time => end_time})
            data = Appointment.where("first_name = 'ayria'")
            p data.length
            if data.length > 1
                errors.add(:overlapping , "Dates are overlapping an existing appointment")
            end
        rescue
        end
    end


end