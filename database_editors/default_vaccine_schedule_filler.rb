require 'sinatra/activerecord'
require './models/default_vaccine_schedule'
require './models/vaccination_schedule'


#Fill Default vaccination table
t = DefaultVaccineSchedule.new
t.vaccine_name = "bcg_dose1"
t.due_date =0
t.url ="https://en.wikipedia.org/wiki/BCG_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hepb_dose1"  
t.due_date =0
t.url ="https://en.wikipedia.org/wiki/Hepatitis_B_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hepb_dose2"  
t.due_date =28
t.url ="https://en.wikipedia.org/wiki/Hepatitis_B_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hepb_dose3" 
t.due_date  =28+56
t.url ="https://en.wikipedia.org/wiki/Hepatitis_B_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="poliovirus_dose1" 
t.due_date  =0
t.url ="https://en.wikipedia.org/wiki/Polio_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="poliovirus_dose2" 
t.due_date  =28
t.url ="https://en.wikipedia.org/wiki/Polio_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="poliovirus_dose3" 
t.due_date  =28+28
t.url ="https://en.wikipedia.org/wiki/Polio_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="dtp_dose1" 
t.due_date =42
t.url ="https://en.wikipedia.org/wiki/DPT_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="dtp_dose2"
t.due_date  =42+28
t.url ="https://en.wikipedia.org/wiki/DPT_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="dtp_dose3" 
t.due_date =42+28+28
t.url ="https://en.wikipedia.org/wiki/DPT_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="dtp_dose4" 
t.due_date =42+28+28+180
t.url ="https://en.wikipedia.org/wiki/DPT_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="dtp_dose5"
t.due_date  =42+28+28+180+1095
t.url ="https://en.wikipedia.org/wiki/DPT_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hib_dose1"
t.due_date  =42
t.url = "https://en.wikipedia.org/wiki/Hib_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hib_dose2"
t.due_date  =42+28
t.url = "https://en.wikipedia.org/wiki/Hib_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hib_dose3"
t.due_date  =42+28+28
t.url = "https://en.wikipedia.org/wiki/Hib_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hib_dose4"
t.due_date  =42+28+28+180
t.url = "https://en.wikipedia.org/wiki/Hib_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="pcv_dose1"
t.due_date  =42
t.url = "https://en.wikipedia.org/wiki/Pneumococcal_conjugate_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="pcv_dose2"
t.due_date  =42+28
t.url = "https://en.wikipedia.org/wiki/Pneumococcal_conjugate_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="pcv_dose3"
t.due_date  =42+28+28
t.url = "https://en.wikipedia.org/wiki/Pneumococcal_conjugate_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="pcv_dose4"
t.due_date  =42+28+28+180
t.url = "https://en.wikipedia.org/wiki/Pneumococcal_conjugate_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="rv_dose1"
t.due_date   =42
t.url = "https://en.wikipedia.org/wiki/Rotavirus_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="rv_dose2"
t.due_date   =42+28
t.url = "https://en.wikipedia.org/wiki/Rotavirus_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="rv_dose3"
t.due_date   =42+28+28
t.url = "https://en.wikipedia.org/wiki/Rotavirus_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="typhoid_dose1"
t.due_date  =270
t.url = "https://en.wikipedia.org/wiki/Typhoid_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="typhoid_dose2"
t.due_date  =270+450
t.url = "https://en.wikipedia.org/wiki/Typhoid_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="mmr_dose1"
t.due_date  =270
t.url = "https://en.wikipedia.org/wiki/MMR_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="mmr_dose2"
t.due_date  =270+180
t.url = "https://en.wikipedia.org/wiki/MMR_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="varicella_dose1"
t.due_date  =365
t.url = "https://en.wikipedia.org/wiki/Varicella_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="varicella_dose2"
t.due_date  =365+90
t.url = "https://en.wikipedia.org/wiki/Varicella_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hepa_dose1"
t.due_date   =365
t.url = "https://en.wikipedia.org/wiki/Hepatitis_A_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hepa_dose2"
t.due_date   =365+180
t.url = "https://en.wikipedia.org/wiki/Hepatitis_A_vaccine"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="tdap_dose1"
t.due_date   =2555
t.url = "https://en.wikipedia.org/wiki/DPT_vaccine#Tdap"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hpv_dose1" 
t.due_date   =3285
t.url = "https://en.wikipedia.org/wiki/HPV_vaccines"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hpv_dose2"
t.due_date    =5475
t.url = "https://en.wikipedia.org/wiki/HPV_vaccines"
t.save

t = DefaultVaccineSchedule.new
t.vaccine_name ="hpv_dose3"
t.due_date    =5475
t.url = "https://en.wikipedia.org/wiki/HPV_vaccines"
t.save