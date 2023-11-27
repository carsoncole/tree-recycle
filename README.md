** Documentation is being revamped and is currently far from complete.

# Tree Recycle

Host and manage a Christmas tree recycling event fundraiser with Tree Recycle. Inspired by the needs of our Scout Troop and the complexity of taking donations and figuring out how to organize the pickup of trees over a wide area, Tree Recycle can at a minimum do the following:

- provide a public website for taking tree pickup reservations;
- organize pick-up addresses within your pre-defined Zones and Routes;
- take online donations utilizing Stripe;
- retain reservations year-over-year to allow for marketing to prior year customers with email reminders of a current years' event;
- send out email reservation confirmations, donation receipts and marketing emails.

Our Troop uses this application and it can be viewed at [https://treerecycle.net](https://treerecycle.net).

If you have any questions concerning this application, feel free to email me at carson.cole@gmail.com.


## REQUIREMENTS

### Heroku

Tree Recycle can be installed on, and instructions are for, [Heroku](https://heroku.com/), a PaaS cloud hosting service, however there is nothing directly configured for Heroku so it could be installed in the cloud or locally.

### Database

A database for the application is required and Heroku provides a number of choices that you can add directly through the web interface. For this application, I recommend the 'Heroku Postgres' addon, and you should add it to your application. You can select the least expensive plan as you have the ability to upsize at a later time. There may be a free plan that provides for up to 10,000 rows, which you can use initially and upgrade as your needs change.

### Redis

A Redis addon must be enabled on Heroku to provide the live functionality such as Admin header new messages counts, and live updating of reservations, in the Admin section. This is required as the appliation will not function without it. Search the addons for 'Heroku Data for Redis' and add it with the least expensive plan.


### Mapping service

A mapping service is required to provide geocoding and geofencing services. AWS Mapping is configured by default but this can be changed in ``` config/intializers/geocoder.rb```. For AWS, you'll need an account, and you'll get your API credentials which should be configured in your credentials file `config/credentials.yml.enc`.

### USPS

USPS API access is needed for address verification (https://www.usps.com/business/web-tools-apis/). A required key should be configured in the credentials `config/credentials.yml.enc` file.


### Email

An email provider, such as Gmail, can be configured for reservation notifications, reminders, cancellations, marketing emails, and donation receipts. The default configuration is Gmail, as it is free and normally would provide a high enough daily limit (300-500 emails) to meet the needs of most users.

It is not recommended that you send out marketing emails in large quantities as they could be flagged as spam by both Gmail and the receiving email servers. There is a batch quantity limit setting where you can set the maximum number of emails to send at a time. The exact limits that Gmail applies to outgoing quantity limits are uncertain, but believed to be 20/hour, or 500 over a rolling 24 hour period. Depending on your emailing needs, there are alternate commercial email providers that you can integrate at substantially higher outgoing levels.

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


### SMS notifications

An SMS service is needed if you want to be able to send SMS notifications. This is particularly useful when a driver can not locate a tree pickup. They can indicate a missing tree in the app and it will immediately send an SMS notification. It is not uncommon for people to forget to put their trees out for pickup. SMS notifications are configured to send via Twilio, but this could be modified for any service in the Sms class `sms.rb`. Keys must be set in the Rails ```config/credentials.yml.enc``` file.


## Installation

You will need to install the application locally, before which you can then deploy to your Heroku account.

1. Application install

Install Ruby on Rails 7, Ruby > 3.0.0, and PostgreSQL. Then `bundle install` to install the necessary gems.

2. Setup the database.

To setup the database, which gets its configuration from `db/database.yml`:

    rails db:create

For development use, there is seed data that can be loaded if you want to see the site configured with zones, routes, and reservations and other data by

    rails db:seed

In production, Heroku will configure settings when you initially deploy.

3. Edit the config file `config/initializers/constants.rb`, accordingly.

4. Update the Sources.

When taking reservations, users select from a drop down where they heard about the event. The choices are hard-coded as an Enum in `reservation.rb` and should be configured to fit your own community.

    enum :heard_about_source, { facebook: 1, safeway_flyer: 6, christmas_tree_lot_flyer: 7, nextdoor: 2, newspaper: 8, roadside_sign: 3, 'Town & Country reader board': 9, word_of_mouth: 4, email_reminder_from_us: 5, other: 99 }

5. Startup

To start up the application:

    % bundle install
    % rails s


6. Configure admin users

Users in the application are only necessary for management of the event. The initial adminstrator/owner user should be created directly in the console.

    %  User.create(email: 'admin email', password: 'admin password', role: 'administrator')


Once the initial user is setup, you can manage the user roles (`viewer`, `editor`, `administrator`) through the UI, after any user signs up at `/sign_up`. The ability to sign up is configured in `initializers/clearance.rb`

    config.allow_sign_up = true

6. Add a worker

The application does a lot of background work in the handling of emails and routing, such as sending a confirmation email when a reservation is made, or cancellation email, if cancelled, so you will need a Worker enabled. The worker will look for jobs that are stored in your database in the `delayed_jobs` table.

On Heroku, once your code has been deployed, there will a Worker listed under Resources, which you will need to enable. Until you enable it, no emails will be sent from your application.


#### Setup


To start up the application:

    % bundle install
    % rails s


### Driver

The driver component of the app is at `/driver`. By default, resources under this namespace are open publicly by default, with the risks being that reservation personal information as well as the ability to toggle the status of the pickup. It is suggested that once your app is live, that you enable authenticated accessed by configuring a `Driver secret key` in admin `Settings`. Then access to these resources require the initial request to have the key, but subsequent requests do not, unless the key is reset in the settings.

With a driver secret key of `happy`: `/driver/key=happy`. So the URL for accessing the driver part of the app:

    https://example.com/driver?key=happy


### Sending marketing emails

Marketing emails can be sent in Settings and there are two configured (Marketing Email #1, Marketing Email #2). The batch email size refers to the number of emails to send at a time. Depending on your mail provider, you may want to set this to a number that does not exceed any daily sending limit. If sending through Gmail, the estimated limit is 500 per day. When you send a batch, it will send the next set (if any) of emails that have not already been sent the email, so there will be no duplicates. It is reflected in a reservation when marketing emails have been sent. It is also reflected in the reservation log.


## Mapping

Reservations are mapped into admin-defined routes. When entered, reservations will be checked for existence within Routes by either 1) a Route that is nearest to it (each Route has a base address), or 2) with a Route that has polygon defined for it. Multi-point polygons can be entered for each route.

### Routes

Routes need to be defined by first, a base address, and optionally, a polygon made up of 3 or more coordinates (entered counter-clockwise). Polygons can be defined to contain specific roads and addresses, and generally polygons should abut, not overlay, other Route polygons.

Routes should essentially be an area that could contain a manageable group of tree pickups. A pickup driver could be assigned to one or more Routes.

Maps of all pickups within a route are available in `Routes` in the adminstration section of the application. Clicking on each pickup on the map will show if its been picked up and has a link to directions to the pick-up.

![Screenshot](app/assets/images/map.png)

### Zones

Zones are made up of Routes and are used for organizational purposes so that Zone leaders can be defined to oversee groups of Routes.



## Secret credentials

The app maintains application secrets in a credential file within the codebase at `/credentials.yml.enc`. The secrets include passwords and keys to access email providers, Twilio and more. You will add your own secrets to this file, which will be encrypted, and then deployed within your codebase to be used in Production on Heroku.

Delete any existing `config/credentials.yml.enc` file. Initialize your own secrets file:

    % EDITOR=vim rails credentials:edit

This will create your initial credentials file and open it in an editor. Copy the contents of `/config/credentials_sample.yml` as your initial template and edit it accordingly.

Exit the credentials file with `esc-:-q`. This will save the file and the key for decrypting it into `config/master.key`. Copy this key and add it to your Heroku Vars (see App Credentials below), under your application settings, with a key value of `RAILS_MASTER_KEY`. This key is what Heroku will use to access the credentials file.

On Heroku, you need to provide the master key so the file can be decrypted. You can do this through the Heroku UI, or in the Heroku console:


    heroku config:set RAILS_MASTER_KEY=<your-master-key>


## Error monitoring (optional)

Rollbar.io is integrated for error monitoring, This can be easily replaced with other services. The configuration file is `config/initializers/rollbar.rb` and the access token is stored in the Rails credentials file, which is the only thing that needs to be updated for it to work within your own Rollbar account. Rollbar is free for 5,000 errors a month, which should easily cover it.

To remove Rollbar completely, removed from the ```Gemfile``` and ```initializers/rollbar.rb```.



## Installation on Heroku

### 1. Create Heroku.com account and application

Create a Heroku account, and then create a new application through the web interface.  Instructions for doing this on Heroku is well documented on Heroku.com.

### 3. Add Redis

A Redis addon must be enabled on Heroku to provide the live functionality such as Admin header new messages counts, and live updating of reservations, in the Admin section. This is required as the appliation will not function without it. Search the addons for 'Heroku Data for Redis' and add it with the least expensive plan.

### 4. Download the repo locally, deploy to Heroku

The application needs to be downloaded locally, with modifications made concerning your own deployment, then deployed to Heroku. 

Download this repo from Github. Instructions on doing this are widely available.


### 5. Deploy to Heroku.com

Deploy the code to Heroku.com. Instructions can be found on Heroku.com.

### 6. Add a Worker

The application does a lot of background work in the handling of emails and routing, such as sending a confirmation email when a reservation is made, or cancellation email, if cancelled, so you will need a Worker enabled. The worker will look for jobs that are stored in your database in the `delayed_jobs` table. 

Once your code has been deployed, there will a Worker listed under Resources, which you will need to enable. Until you enable it, no emails will be sent from your application.

#### Configuration

Once your application has been deployed to Heroku, you should be able to access to public portal, but you will need a login to access the Admin portal. You will need to create an admin user through the console that can be access via your local installation of the applicdation:

    % heroku console
    % User.create(email: 'john.doe@example.com', password: [password])


## Testing

There are Rails minitest tests, including system tests.

For mailers, previews exist for the confirmation and reminder emails. To view in `development`:

    http://localhost:3000/rails/mailers/


## Seed Data

Trial seed data can be loaded. This will create the initial admin user (admin@example.com, password: password), route, zone and reservation data. Use this data to only preview the apps functionality, not for production purposes.

    rails db:seed


## Favicons

You can replace the favicons and Apple touch icons, which are reference in `shared/_head.html.haml`, on the site `https://iconifier.net/index.php?iconified=20221118063655_tree-red-touch-icon.png`.

## Copyright

Copyright (c) 2022, 2023 [Carson Cole](https://carsonrcole.com). See MIT-LICENSE for details.
