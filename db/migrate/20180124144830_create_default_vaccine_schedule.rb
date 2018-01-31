#Database table to store the default values for vaccine table
class CreateDefaultVaccineSchedule < ActiveRecord::Migration[5.1]
 def up
  	create_table :default_vaccine_schedules do |t|
      t.string :vaccine_name
      t.integer :due_date
      t.string :url
  	end
    remove_column :default_vaccine_schedules, :id
  end

  def down
  	# Drop default_vaccine_schedule table
  	drop_table :default_vaccine_schedules
  end

end
