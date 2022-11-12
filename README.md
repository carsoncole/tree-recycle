# Tree Recycle

The Tree Recycle application provides customizable public website that does the multiple jobs of taking tree recycle pick-up reservations and donations, sending out confirmations and a reminder on the pick-up date. On the administrative side, the application organizes reservations into pickup routes, and integrating with Google and Apple Maps to show pickup locations.

This application was originally designed to assist in managing a BSA Scout tree recycling fundraiser, however it could be used by any organization.

## Requirements

Ruby on Rails 7, Ruby ~> 3.0.0, and PostgreSQL.

This app requires USPS API access for address verification (https://www.usps.com/business/web-tools-apis/). A required key should be configured in the Credentials `credentials.yml.enc` file.

## Installation

This is a Ruby on Rails 7, Ruby 3.0+ application. You will need to have an server instance that has both Rails and Ruby installed.

### Database - PostgreSQL

Currently configured for PostgreSQL, but the `database.yml` can be configured for a different database.

The database can be created with `rails db:setup`, which will do all of `db:create`, `db:schema:load`, `db:seed`. The seeds file contains sample data is is not need when you go into production. Or you can simply delete/create the data through the UI.


### Settings

The application derives Reservation, and fundraiser defaults, all of can be configured through the UI in `Admin > Settings`.


### Email notifications

Configure each environment with mail settings. environment file containts ActionMailer configuration settings. The default settings are with Gmail, but this can be changed to any SMTP provider. Credentials are managed in the Rails credentials file.

```
config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => Rails.application.credentials.mailer.production.username,
    :password             => Rails.application.credentials.mailer.production.password,
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
```

The mailer itself should be updated to default to the sending address:

application_mailer.rb
```
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
```

### Setup

To start up the application locally, do `bundle install` and 'rails s'.


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


### Custom Credentials

Tree Recycle uses Rails' custom credentials, stored in `config/credentials.yml.enc`, to hold all necessary access keys to various external services. A master key to access it is stored in `config/master.key` or alternatively is in the environment variable ENV["RAILS_MASTER_KEY"]. You will need to generate a new master key for this file, which will happen automatically when you open the file with:

```
EDITOR=vim rails credentials:edit
```

See the sample credentials file `config/credentials_sample.yml` for all of the necessary secrets.


## Use

Create users in the console who will have administrator access.

```
User.create(email: 'admin email', password: 'admin password')
```

Reservations is the resource for holding tree pickup reservations and they are created by customers without any necessary login, [TODO] but are retrievable and changeable using a custom link sent to customers upon initial creation and any updates.

Registered users are administrators that can access all of the resources. Administrators (users) need to be manually created in the database as there is no access to signups through the UI.

Routes are used to create areas of reservations, for convenient pick ups. Routes are set with a center point and a radius distance in miles. Reservations can also be manually assigned to a Route.

There is an admin setting `Emailing enabled?` that controls whether emails are sent out.


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

## Copyright

Copyright (c) 2022 Carson Cole. See MIT-LICENSE for details.
