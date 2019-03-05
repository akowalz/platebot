# PlateBot

PlateBot is a way to get dinner saved for you when you're on the go.  It was
designed for [MOSAIC Co-op](http://mosaiccoop.org), which holds nightly house
dinners and allows its members to request "late plates" be saved for them when
they won't be around at dinnertime.  The old system to request a late plate was
a Google Spreadsheet that members could add themselves to nightly, but this is
clunky and difficult when you are on the go.  PlateBot utilites the [Twilio
API](http://twilio.com) to introduce an SMS text message interface for late plating.
Now, if wherever you are, you send a text and know that dinner will be waiting
at home.

PlateBot is hosted at [plate-bot.com](http://www.plate-bot.com).  For
information about the query interface, see the [help page](http://www.plate-bot.com/help)

## Developing

Create the database (default configuration uses Postgres):

```
bundle exec rake db:reset
```

Start the server:

```
bin/rails s
```

Run tests:

```
bin/rails test
```

### Google Login

A `.env` file is necessary for Google Login.
