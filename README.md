# Tree Recycle

Web application for advertising and managing a tree recycling fundraiser. People enter reservations to have trees picked up as well as make an online donation. On the recycling day, the app will output distributed driving reports for groups of drivers to pick up trees from set areas. The app also generates text and email messages to reservees confirming that their tree has been picked up.

Tree Recycle is intended to be simple, well-tested, and easy to maintain

## Requirements

Ruby on Rails 7, Ruby ~> 3.0.0, and PostgreSQL.

This app requires USPS API access for address verification (https://www.usps.com/business/web-tools-apis/). A required key should be configured in the Credentials `credentials.yml.enc` file.

## Configuration

### Installation
To install:

```
bundle install
```

Create users in the console who will have administrator access.

```
User.create(email: 'admin email', password: 'admin password')
```

Administrator settings information should be filled out as the information is used throughout the application.


### Mailers
There are standard mailers for confirming a reservation `confirmed_reservation_email`, and a reminder `pick_up_reminder_email`. These mailer message templates utilize information from the settings, such as the pick-up date, so test and review before triggering a mass mailing and make changes as necessary.

There is an admin setting `Emailing enabled?` that controls whether emails are sent out. To avoid sending mailers twice to a recipient, reservations will be toggled true for either `is_confirmation_email_sent: true` or `:is_reminder_email_sent: true`.

### Custom Credentials

Tree Recycle uses Rails' custom credentials, stored in `config/credentials.yml.enc`, to hold all necessary access keys to various external services. A master key to access it is stored in `config/master.key` or alternatively is in the environment variable ENV["RAILS_MASTER_KEY"]. You will need to generate a new master key for this file, which will happen automatically when you open the file with:

```
EDITOR=vim rails credentials:edit
```

See the sample credentials file `config/credentials_sample.yml` for all of the necessary secrets.


## Use

Reservations is the resource for holding tree pickup reservations and they are created by customers without any necessary login, [TODO] but are retrievable and changeable using a custom link sent to customers upon initial creation and any updates.

Registered users are administrators that can access all of the resources. Administrators (users) need to be manually created in the database as there is no access to signups through the UI.

Zones are used to create areas of reservations, for convenient pick ups. Zones are set with a center point and a radius distance in miles. Reservations can also be manually assigned to a Zone.

## Mapping

Reservations are grouped by admin-defined zones with a center point and a set radius. In all cases, each reservation will be grouped into the Zone that is nearest to it. This approach is not without problems as its possible that reservations that border multiple zones, may not be grouped the most efficiently.

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
