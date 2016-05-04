class Appointment < ActiveRecord::Base
    # Appointment model with several validation methods
    attr_accessor :skip_date_check
    validates :first_name, :last_name, :start_time, :end_time, presence: true
    before_validation :start_and_end_times_are_blank, on: [:create, :update]
    before_validation :start_and_end_date_are_in_the_past, on: [:create, :update]
    before_validation :dates_are_overlapping, on: [:create, :update]


    # Here we filter results based on the start and end times.
    # We want to make sure we are returning the results that overlap
    # We apply this filter to the list method if both dates and no id are present
    scope :filter, lambda { |params|

        params["start_time"] = DateTime.parse(params["start_time"])
        params["end_time"] = DateTime.parse(params["end_time"])
        where("(((start_time BETWEEN :start_time AND :end_time)
                                    OR (end_time BETWEEN :start_time AND :end_time))
                                    OR (start_time <= :start_time AND end_time >= :end_time))",
                                    {:start_time => params["start_time"],:end_time => params["end_time"]})
    }

    def start_and_end_times_are_blank
        # We check the presence of the start and end times
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
        # Ensure the dates are not in the past
        if start_time < Time.current
            errors.add(:start_time, "Time cannot be in the past")
        elsif end_time < Time.current
            errors.add(:end_time, "Time cannot be in the past")
        end
    end

    def dates_are_overlapping
        # If we have times in the request
        if !self.skip_date_check && start_time && end_time
            # Ensure the dates are not overlapping when creating or updating a resource
            data = Appointment.where("(((start_time BETWEEN :start_time AND :end_time)
                                        OR (end_time BETWEEN :start_time AND :end_time))
                                        OR (start_time <= :start_time AND end_time >= :end_time))",
                                        {:start_time => start_time,:end_time => end_time})
            if data.length > 0
                errors.add(:overlapping , "Dates are overlapping an existing appointment")
            end
        end
    end
end