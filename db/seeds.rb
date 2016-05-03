require 'csv'
require 'date'

# This will import the data from the CSV. Headers are taken into account.
begin
  puts
  csv = CSV.read(Rails.root.join('db/appt_data.csv'), {encoding: "UTF-8", headers: true, header_converters: :symbol})

  if csv.any?
    Appointment.delete_all
    csv.each do |appt|
        appt_hash = appt.to_hash
        appt_hash[:start_time] = DateTime.strptime(appt_hash[:start_time], "%m/%d/%y %H:%M").to_s(:db)
        appt_hash[:end_time] = DateTime.strptime(appt_hash[:end_time], "%m/%d/%y %H:%M").to_s(:db)
        Appointment.create!(appt_hash) do |a|
            p a
        end
    end
  else
    puts "The file is empty.\nPlease confirm that the file contains data before attempting to seed the database."
  end

rescue CSV::MalformedCSVError, StandardError => e
  puts "Error importing data from csv file.\nException Message: #{e}"
end