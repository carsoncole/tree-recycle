# Tree Recycle

Host and manage a tree recycling fundraiser website with Tree Recycle. It provides a customizable public website, and handles the multiple jobs of 1) taking tree recycle pick-up reservations, 2) taking donations, and 3) route management, organizing reservations into zones and routes for an organized pickup process.

## Requirements

This is a Ruby on Rails 7 application, dependent on Ruby ~> 3.0.0, and PostgreSQL as the database.

## Installation

This installed has been configured to run on [Heroku](https://heroku.com/), but is easily modified to work on any cloud provider. Install Ruby on Rails 7, Ruby > 3.0.0, and PostgreSQL. Then `bundle install` to install the necessary gems.

### Database

To setup the database, which gets its configuration from `db/database.yml`:

```
rails db:create
```

For development use, there is seed data that can be loaded if you want to see the site configured with zones, routes, and reservations and other data by

```
rails db:seed
```


### App Credentials

Tree Recycle uses Rails' custom credentials, stored in `config/credentials.yml.enc`, to securely hold all environment variables, including access keys to various external services. A master key to access it is stored in `config/master.key` or alternatively is in the environment variable ENV["RAILS_MASTER_KEY"]. You will need to generate a new master key for this file, which will happen automatically when you open the file with:

```
EDITOR=vim rails credentials:edit
```

See the sample credentials file `config/credentials_sample.yml` for all of the necessary secrets.

On Heroku, you need to provide the master key so the file can be decrypted. You can do this through the Heroku UI, or in the Heroku console:

```
heroku config:set RAILS_MASTER_KEY=<your-master-key>
```


### App Constants

Set the default application settings in `config/initializers/constants.rb`. 

#### Reservation sources

When taking reservations, users select from a drop down where they heard about the event. The choices are hard-coded as an Enum in `reservation.rb` and should be configured.

reservation.rb
```
enum :heard_about_source, { facebook: 1, safeway_flyer: 6, christmas_tree_lot_flyer: 7, nextdoor: 2, newspaper: 8, roadside_sign: 3, 'Town & Country reader board': 9, word_of_mouth: 4, email_reminder_from_us: 5, other: 99 }
```

### USPS API Access

This app requires USPS API access for address verification (https://www.usps.com/business/web-tools-apis/). A required key should be configured in the Credentials `credentials.yml.enc` file.


### Email notifications

Configure each environment with mail settings. Setting and credentials are managed in the Rails credentials file.



production.rb

```
  config.action_mailer.smtp_settings = {
    :address              => Rails.application.credentials.mailer.development.address,
    :port                 => Rails.application.credentials.mailer.development.port,
    :user_name            => Rails.application.credentials.mailer.development.user_name,
    :password             => Rails.application.credentials.mailer.development.password,
    :authentication       => Rails.application.credentials.mailer.development.authentication,
    :tls                  => Rails.application.credentials.mailer.development.tls,
    :enable_starttls_auto => Rails.application.credentials.mailer.development.enable_starttls_auto
```

The mailer itself should be updated to default to the sending address:

application_mailer.rb
```
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
```

The default URL for mail is set in the environment configuration file:

```
config.action_mailer.default_url_options = { host: 'site@example.com' }
```

### SMS notifications

SMS notifications are configured to send via Twilio, but this could be modified for any service in the Sms class `sms.rb`. Keys must be set in the Rails credentials file.

### Setup

To start up the application:

```
bundle install
rails s
```


### Heroku
The following instruction apply to installations on Heroku.

#### Configuration

Create a new app in Heroku. On the Heroku Config Vars page, add the Rails master key for decrypting the credentials to `RAILS_MASTER KEY`.

The included `Procfile` has instructions to migrate the database on every deploy.

To sign-in, you will need to create an admin user through the console.

```
% heroku console
> User.create(email: 'john.doe@example.com', password: [password])
```


## Use

Users in the application are only necessary for management of the event. The initial adminstrator/owner user should be created directly in the console.

```
User.create(email: 'admin email', password: 'admin password', role: 'administrator')
```

Once the initial user is setup, you can manage the user roles (`viewer`, `editor`, `administrator`) through the UI, after any user signs up at `/sign_up`. The ability to sign up is configured in `initializers/clearance.rb`

```
config.allow_sign_up = true
```


### Driver

The driver component of the app is at `/driver`. By default, resources under this namespace are open publicly by default, with the risks being that reservation personal information as well as the ability to toggle the status of the pickup. It is suggested that once your app is live, that you enable authenticated accessed by configuring a `Driver secret key` in admin `Settings`. Then access to these resources require the initial request to have the key, but subsequent requests do not, unless the key is reset in the settings.

With a driver secret key of `happy`: `/driver/key=happy`. So the URL for accessing the driver part of the app:

```
https://example.com/driver?key=happy
```

## Mapping

Reservations are grouped by admin-defined routes with a center point and a set radius. In all cases, each reservation will be grouped into the Route that is nearest to it. This approach is not without problems as its possible that reservations that border multiple routes, may not be grouped the most efficiently.

Maps of all pickups within a route are available in `Routes` in the adminstration section of the application. Clicking on each pickup on the map will show if its been picked up and has a link to directions to the pick-up.

![Screenshot](app/assets/images/map.png)

## Testing

There are Rails minitest tests, including system tests.

For mailers, previews exist for the confirmation and reminder emails. To view in `development`:

```
http://localhost:3000/rails/mailers/reservations_mailer/confirmed_reservation.html
```

```
http://localhost:3000/rails/mailers/reservations_mailer/pick_up_reminder_email.html
```


## Seed Data

For testing and trial use, seed configuration, reservation, and admin user data can be loaded with

```
rails db:seed
```

## Favicons

You can replace the favicons and Apple touch icons, which are reference in `shared/_head.html.haml`, on the site `https://iconifier.net/index.php?iconified=20221118063655_tree-red-touch-icon.png`.

## Copyright

Copyright (c) 2022 [Carson Cole](https://carsonrcole.com). See MIT-LICENSE for details.
