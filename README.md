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

### Mailers
There are standard mailers for confirming a reservation `confirmed_reservation`, and a reminder `TBD`. These mailer message templates utilize information from the settings, such as the pick-up date, so test and review before triggering a mass mailing and make changes as necessary.

## Use

Reservations is the resource for holding tree pickup reservations and they are created by customers without any necessary login, [TODO] but are retrievable and changeable using a custom link sent to customers upon initial creation and any updates.

Registered users are administrators that can access all of the resources. Administrators (users) need to be manually created in the database as there is no access to signups through the UI.

Zones are used to create areas of reservations, for convenient pick ups. Zones are set with a center point and a radius distance in miles. Reservations can also be manually assigned to a Zone.

## Seed Data

For testing and trial use, seed configuration, reservation, and admin user data can be loaded with

```
rails db:seed
```

## Copyright

Copyright (c) 2022 Carson Cole. See MIT-LICENSE for details.
