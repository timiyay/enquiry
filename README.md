# Enquiry 

After a user submits your site's contact form, __enquiry__ will help you run
your post-submit actions. These actions will be run as separate processes, by plugging
in to a Ruby-based worker library like Sidekiq.

It currently has support for:  
* sending notification emails to the site owner
* subscribing the enquiry to a Mailchimp list
* adding the enquiry's details to a Google Sheet

## Build Status
master: ![Build Status](https://travis-ci.org/timiyay/enquiry.svg?branch=master) [![Code Climate](https://codeclimate.com/github/timiyay/enquiry/badges/gpa.svg)](https://codeclimate.com/github/timiyay/enquiry)

develop: ![Build Status](https://travis-ci.org/timiyay/enquiry.svg?branch=develop)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enquiry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enquiry

## Usage

```ruby
require 'enquiry'

# call class methods directly
Enquiry.add_to_google_sheet(...)
Enquiry.subscribe_to_mailchimp_list(...)
Enquiry.notify_by_email(...)

# or, pass an object that implements
# - to_email
# - to_google_sheet
# - to_mailchimp
# ...and run all available actions
Enquiry.new(enquiry_object).sync
```
