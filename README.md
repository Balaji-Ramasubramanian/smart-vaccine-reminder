# smart-vaccine-reminder
It is a Facebook Messenger Bot that helps you on reminding the vaccination days for your kids. It is in development mode.
## Overview
It is a Facebook Messenger Bot that has following features, 
- Sends reminders about the Vaccination dates for their kids
- Helps to check the provided vaccines
- Helps to check Vaccines to be provide in future
- Details about each vaccines
- Subscription 
- Natural Language Processing support
- Provide the data to Hospitals through Google Sheets
- Gives the access to Edit details of a user by Google sheets and make update to Database 

To know about [What is Facebook Messenger Bot](https://developers.facebook.com/docs/messenger-platform/getting-started/app-setup)

## Requirements
The list of requirements to be installed,
- Ruby
- MySQL Database
- Online hosting server or a webhook
- Wit Project(For Natural Language Processing)

## Getting Started
First you'll need to fork and clone this repo

Open Terminal. Change the current working directory to the location where you want the cloned directory to be made.

```
git clone https://github.com/Balaji-Ramasubramanian/smart-vaccine-reminder.git
```
Let's get all our dependencies setup:
```
 bundle install 
```

## Configuration
You need to change the **.env** file with your appropriate access tokens. You need to provide the following details,
- Facebook page access token
- Verify token for your Bot
- App secret token
- Wit access token
- Database Host
- Database Name
- Database Username
- Database Password

## Migrate Database
First you'll need to migrate the database tables
```
rake db:migrate
```

It consists of 2 tables,
- default_vaccine_schedule
- vaccination_schedule

#### default_vaccine_schedule:
This table consists of the vaccines and their details. It includes the following,
- Vaccine name.
- Number of days after which the particular vaccine has to be given to the kid.
- URL that has the details of that vaccine.

#### vaccination_schedule
This table contains the users and their kid details, vaccination days.

## Initializing default_vaccine_schedule table:
After the migration of Database tables, you need to fillup the default_vaccine_schedule table.
To do that run the following command from your root of the project file
```
 ruby database_editors/default_vaccine_schedule_filler.rb 
 ```
 This will automatically fills the default values to the table.

## Deploying your app:
#### Deploying with heroku:
To know about Heroku CLI, [click here](https://devcenter.heroku.com/articles/heroku-cli)
For this project you need the following resources from heroku,
- ClearDB MySQL :: Database
- Heroku Scheduler

We wil update instruction for deploying the app in AWS, Google Cloud Microsoft Azure shortly.


