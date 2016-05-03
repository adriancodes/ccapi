class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.text :comment
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.timestamps null: false
    end
  end
end