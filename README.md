## About

This collector forms part of the Data Insight Platform. It collects the
latest content for the leader for the public dashboard and broadcasts
that message on a message bus.

## Format

The message is JSON and follows the following strcuture.

    {
      "envelope":{
        "collected_at":"2012-07-31T10:46:25+01:00",
        "collector":"leader"
       },
       "payload":{
          "content":"Some content of interest went up 20%",
          "author":"Gareth Rushgrove"
       }
    }

## Dependencies

Bundler manages the ruby dependencies so you'll want a quick:

    bundle install

If you're using the broadcast command you'll need a message queue
listening. This defaults to listening on localhost on 5672 but can be
overridden with the AMQP environment variable.

## Usage

The first run requires the Oauth token from Google for the given
application. Once you have that you can run:

    bundle exec bin/leader-collector --token={auth token from Google} print

Following runs just require the following, as the refresh token will
have been stored. Repassing the original auth token will fail as it's
now invalid.

    bundle exec bin/leader-collector print

Full help details can be found with:

    bundle exec bin/leader-collector help
