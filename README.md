# Tree Recycle

Host and manage a Christmas tree recycling event fundraiser with Tree Recycle. Inspired by the needs of our Scout Troop and the complexity of taking donations and figuring out how to organize the pickup of trees over a wide area, Tree Recycle can at a minimum do the following:

- Provide a public website for taking tree pickup reservations;
- Organize pick-up addresses within your pre-defined Zones and Routes;
- Take online donations utilizing Stripe;
- Handle the retention of reservations year-over-year to allow for contacting prior year customers to tell them about this years' event;
- Send out email reservation confirmations, donation receipts and marketing emails.

Our Troop uses this application and it can be viewed at [https://treerecycle.net](https://treerecycle.net).

## What is Required?

Tree Recycle has been designed to be simple to use and install on [Heroku](https://heroku.com/), which has a simple UI, a straight-forward deployment process, and is hosted on AWS, all for a reasonable price. Once installed, the application is designed for continuous running from year-to-year, carrying over reservations and their emails for marketing to prior year recyclers.

## Installation

This application has been configured to run on [Heroku](https://heroku.com/), but could be modified to work on any cloud provider.  Heroku is a good choice as it provides a simple interface for managing applications, and the deployment process is straight-forward.

### 1. Create a Heroku.com account

Create an account, initialize your app. Instructions for doing this on Heroku is well documented on Heroku.com.

### 2. Add a database - PostgreSQL

A PostgreSQL addon must enabled on Heroku as the database. On Heroku, search the addons for 'Heroku Postgres' and add it to your account. This will addon will serve as your database. You can select the least expensive plan as you have the ability to upsize at a later time.

### 3. Add Redis

A Redis addon must be enabled on Heroku to provide the live functionality such as Admin header new messages counts, and live updating of reservations, in the Admin section. This is required as the appliation will not function without it. Search the addons for 'Heroku Data for Redis' and at it with the least expensive plan.

### 4. Download the repo locally, deploy to Heroku

Download this repo with Git.

### 5. Add a master.key to `/config/master.key`

The app maintains its secrets in a credential files within the codebase. You will add your own secrets locally, and then deploy them to be used in Production on Heroku.



    % EDITOR=vim rails credentials:edit


This will create your initial credentials file and open it in an editor. Copy the contents of `/config/credentials_sample.yml` as your initial template. Exit the credentials file with `esc-:-q`. This will save the file and the key for decrypting it into `config/master.key`. Copy this key and add it to your Heroku Vars (see App Credentials below), under your application settings, with a key value of `RAILS_MASTER_KEY`. This key is what Heroku will use to access the credentials file.


### 6. Add a Worker

The application does a lot of background work in the handling of emails and routing, so you will need a Worker enabled. Under Resources, there should a a worker listed, which you will need to enable.

### 7. Deploy to Heroku.com

Deploy the code to Heroku.com.

#### Configuration

To sign-in, you will need to create an admin user through the console.

  % heroku console
> % User.create(email: 'john.doe@example.com', password: [password])

### Local installation

Install Ruby on Rails 7, Ruby > 3.0.0, and PostgreSQL. Then `bundle install` to install the necessary gems.

#### Database

To setup the database, which gets its configuration from `db/database.yml`:


    rails db:create


For development use, there is seed data that can be loaded if you want to see the site configured with zones, routes, and reservations and other data by


    rails db:seed


In production, Heroku will configure settings when you initially deploy.

#### App Credentials

Tree Recycle uses Rails' custom credentials, stored in `config/credentials.yml.enc`, to securely hold all environment variables, including access keys to various external services. A master key to access it is stored in `config/master.key` or alternatively is in the environment variable ENV["RAILS_MASTER_KEY"]. You will need to generate a new master key for this file, which will happen automatically when you open the file with:


    EDITOR=vim rails credentials:edit


See the sample credentials file `config/credentials_sample.yml` for all of the necessary secrets.

On Heroku, you need to provide the master key so the file can be decrypted. You can do this through the Heroku UI, or in the Heroku console:


    heroku config:set RAILS_MASTER_KEY=<your-master-key>


#### App Constants

Basic settings and information for the site is stored in a constants file, `config/initializers/constants.rb`. Edit these accordingly.

##### Reservation sources

When taking reservations, users select from a drop down where they heard about the event. The choices are hard-coded as an Enum in `reservation.rb` and should be configured to fit your own community.

reservation.rb


    enum :heard_about_source, { facebook: 1, safeway_flyer: 6, christmas_tree_lot_flyer: 7, nextdoor: 2, newspaper: 8, roadside_sign: 3, 'Town & Country reader board': 9, word_of_mouth: 4, email_reminder_from_us: 5, other: 99 }


#### USPS API Access

This app requires USPS API access for address verification (https://www.usps.com/business/web-tools-apis/). A required key should be configured in the Credentials `credentials.yml.enc` file.


#### Email

An email provider, such as Gmail, can be configured for reservation notifications, reminders, cancellations, marketing emails, and donation receipts. The default configuration is Gmail, as it is free and normally would provide a high enough daily limit (300-500 emails) to meet the needs of most users. 

Configure each environment with mail settings. Setting and credentials are managed in the Rails credentials file. The sample settings have the correct values if you use Gmail for sending emails. If you use a differnt service, you may need to modify or add to the settings in the individual environment files.


production.rb


      config.action_mailer.smtp_settings = {
      :address              => Rails.application.credentials.mailer.development.address,
      :port                 => Rails.application.credentials.mailer.development.port,
      :user_name            => Rails.application.credentials.mailer.development.user_name,
      :password             => Rails.application.credentials.mailer.development.password,
      :authentication       => Rails.application.credentials.mailer.development.authentication,
      :tls                  => Rails.application.credentials.mailer.development.tls,
      :enable_starttls_auto => Rails.application.credentials.mailer.development.enable_starttls_auto


The mailer itself should be updated to default to the sending address:

application_mailer.rb

    class ApplicationMailer < ActionMailer::Base
      default from: "from@example.com"
      layout "mailer"
    end


The default URL for mail is set in the environment configuration file:

    config.action_mailer.default_url_options = { host: 'site@example.com' }


#### SMS notifications

SMS notifications are configured to send via Twilio, but this could be modified for any service in the Sms class `sms.rb`. Keys must be set in the Rails credentials file.


#### Error monitoring (optional)

Rollbar.io is integrated for error monitoring, This can be easily replaced with other services. The configuration file is `config/initializers/rollbar.rb` and the access token is stored in the Rails credentials file, which is the only thing that needs to be updated for it to work within your own Rollbar account. Rollbar is free for 5,000 errors a month, which should easily cover it.

To remove Rollbar completely, removed from the ```Gemfile``` and ```initializers/rollbar.rb```.

#### Setup

To start up the application:

    % bundle install
    % rails s

## Use

Users in the application are only necessary for management of the event. The initial adminstrator/owner user should be created directly in the console.

    %  User.create(email: 'admin email', password: 'admin password', role: 'administrator')


Once the initial user is setup, you can manage the user roles (`viewer`, `editor`, `administrator`) through the UI, after any user signs up at `/sign_up`. The ability to sign up is configured in `initializers/clearance.rb`

    config.allow_sign_up = true


### Marketing Sources

Update the Reservation class with the sources enum for where a reservation heard about the event.

reservation.rb

    enum :heard_about_source, { newspaper: 8, facebook: 1, safeway_flyer: 6, christmas_tree_lot_flyer: 7, nextdoor: 2,  roadside_sign: 3, 'Town & Country reader board': 9, word_of_mouth: 4, email_reminder_from_us: 5, other: 99 }



### Driver

The driver component of the app is at `/driver`. By default, resources under this namespace are open publicly by default, with the risks being that reservation personal information as well as the ability to toggle the status of the pickup. It is suggested that once your app is live, that you enable authenticated accessed by configuring a `Driver secret key` in admin `Settings`. Then access to these resources require the initial request to have the key, but subsequent requests do not, unless the key is reset in the settings.

With a driver secret key of `happy`: `/driver/key=happy`. So the URL for accessing the driver part of the app:

    https://example.com/driver?key=happy


### Sending marketing emails

Marketing emails can be sent in Settings and there are two configured (Marketing Email #1, Marketing Email #2). The batch email size refers to the number of emails to send at a time. Depending on your mail provider, you may want to set this to a number that does not exceed any daily sending limit. If sending through Gmail, the estimated limit is 500 per day. When you send a batch, it will send the next set (if any) of emails that have not already been sent the email, so there will be no duplicates. It is reflected in a reservation when marketing emails have been sent. It is also reflected in the reservation log.


## Mapping

Reservations are grouped by admin-defined routes with a center point and a set radius. In all cases, each reservation will be grouped into the Route that is nearest to it. This approach is not without problems as its possible that reservations that border multiple routes, may not be grouped the most efficiently.

Maps of all pickups within a route are available in `Routes` in the adminstration section of the application. Clicking on each pickup on the map will show if its been picked up and has a link to directions to the pick-up.

![Screenshot](app/assets/images/map.png)

## Testing

There are Rails minitest tests, including system tests.

For mailers, previews exist for the confirmation and reminder emails. To view in `development`:

    http://localhost:3000/rails/mailers/


## Seed Data

For testing and trial use, seed configuration, reservation, and admin user data can be loaded with

    rails db:seed


## Favicons

You can replace the favicons and Apple touch icons, which are reference in `shared/_head.html.haml`, on the site `https://iconifier.net/index.php?iconified=20221118063655_tree-red-touch-icon.png`.

## Copyright

Copyright (c) 2022, 2023 [Carson Cole](https://carsonrcole.com). See MIT-LICENSE for details.
