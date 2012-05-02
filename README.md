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

![Hermes](http://f.cl.ly/items/030w0Q3g2M0H292w1M2w/Screen%20Shot%202012-03-21%20at%203.41.48%20PM.png)

##Installation

Requires:

* Ruby 1.9.2
* Bundler
* nodejs

Installation:

1. `bundle install`
1. `rake db:setup`
1. Set env variables
1. `rails server thin`
1. [http://localhost:3000](http://localhost:3000)

##ENV Variables

Hermes requires a few services to be available in order to function correctly.

* Twitter
* Sendgrid *optional
* Google *optional

To use these services, you'll need to set the relevant ENV vars containing credentials before you boot up the server:

    export TWITTER_CONSUMER_KEY=foo
    export TWITTER_CONSUMER_SECRET=blah
    export SENDGRID_USERNAME=blah
    export SENDGRID_PASSWORD=blah
    export S3_KEY=blah
    export S3_SECRET=blah
