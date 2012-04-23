#Hermes

Hermes was a re-think of email, to make it more conversation based, and move to a HTTP based protocol. The app included some novel things, such as an asynchronous UI, and automatically filtering of any automated emails. It's now been released under the MIT license.

See the [blog post](http://blog.alexmaccaw.com/open-source-all-the-things) for more information.

##Interesting parts

Server side:

* Using Juggernaut to make an app realtime
* Receiving and parsing email signatures
* Detecting email sent by a computer
* Modeling messages and conversations
* Using the Twitter API
* JSON/Ajax API (docs/API.md)

Client side:

* Spine web app
* Overlays and CSS transforms

##Demo

[http://maccman-hermes.herokuapp.com/](http://maccman-hermes.herokuapp.com/)

##Installation

Requires:

* Ruby 1.9.2
* Bundler

Installation:

1. `bundle install`
1. `rake db:setup`
1. Set env variables:

  `export TWITTER_CONSUMER_KEY=foo`
  `export TWITTER_CONSUMER_SECRET=blah`
  `export SENDGRID_USERNAME=blah`
  `export SENDGRID_PASSWORD=blah`
  `export S3_KEY=blah`
  `export S3_SECRET=blah`

1. `rails server thin`
1. [http://localhost:3000](http://localhost:3000)