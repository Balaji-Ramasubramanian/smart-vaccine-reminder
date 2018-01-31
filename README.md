# smart-vaccine-reminder
This project is a Facebook Messenger Bot which can be used by hospitals to remind parents about their kids vaccination days through Facebook Messenger.

## Overview
This bot has the following features, 
- Sends reminders to parents about the vaccination dates of their kids.
- Helps to check the provided vaccines to a kid.
- Helps to check the vaccines to be provided in future.
- Details about each vaccines.
- Subscription for vaccine reminders.
- Natural Language Processing based support to answer parent's questions about the vaccines.
- Provide the data to hospitals through Google Sheets.
- Gives access to hospitals for editing the details of the kids vaccination days through Google sheets and make an update to the Database.

To know about [What is Facebook Messenger Bot](https://developers.facebook.com/docs/messenger-platform/getting-started/app-setup)

## Requirements
- Ruby
- MySQL Database
- Online hosting server
- Wit Project(For Natural Language Processing)

## Getting Started
First you'll need to fork and clone this repo

Open Terminal. Change the current working directory to the location where you want the cloned directory to be created.

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
- Verify token for your bot
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
This table consists the following details
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


