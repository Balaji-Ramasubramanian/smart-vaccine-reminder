#Database table to store the vaccination schedule
class CreateVaccinationSchedule < ActiveRecord::Migration[5.1]
   def up
  	create_table :vaccination_schedules do |t|
  	# facebook profile details:
  	    t.string 	:parent_facebook_userid
      	t.string	:parent_first_name
      	t.string	:parent_last_name
      	t.string 	:parent_gender
      	t.string 	:locale
      	t.boolean 	:subs
    # kid details:
    	t.string	:kid_name
    	t.date	:kid_dob 
    	t.string	:kid_gender
    # list of vaccines to be provided:
      t.date :bcg_dose1 
      t.date :hepb_dose1 
      t.date :poliovirus_dose1 
      t.date :hepb_dose2 
      t.date :poliovirus_dose2 
      t.date :dtp_dose1 
      t.date :hib_dose1 
      t.date :pcv_dose1 
      t.date :rv_dose1  
      t.date :poliovirus_dose3 
      t.date :dtp_dose2 
      t.date :hib_dose2 
      t.date :pcv_dose2 
      t.date :rv_dose2  
      t.date :hepb_dose3 
      t.date :dtp_dose3  
      t.date :hib_dose3  
      t.date :pcv_dose3  
      t.date :rv_dose3   
      t.date :typhoid_dose1  
      t.date :mmr_dose1 
      t.date :dtp_dose4 
      t.date :hib_dose4 
      t.date :pcv_dose4 
      t.date :varicella_dose1 
      t.date :hepa_dose1 
      t.date :mmr_dose2
      t.date :varicella_dose2 
      t.date :hepa_dose2 
      t.date :typhoid_dose2
      t.date :dtp_dose5  
      t.date :tdap_dose1
      t.date :hpv_dose1 
      t.date :hpv_dose2  
      t.date :hpv_dose3  

  	end
  end
  
  def down
  	drop_table :vaccination_schedules
  end
end
