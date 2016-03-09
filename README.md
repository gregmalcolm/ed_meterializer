Materializer
============

[![Build Status](https://travis-ci.org/gregmalcolm/ed-materializer.svg)](https://travis-ci.org/gregmalcolm/ed-materializer)

This is a simple API for storing material prospecting data for the Elite Dangerous computer game.

Primarily implemented so that [EDDiscovery](https://github.com/EDDiscovery/EDDiscovery)
can have a place to store prospecting materials data.

There are also plans to develop a web frontend

Setup
-----

1) Install Ruby 2.2.4

2) Install Postgres

3) Create a role for postgres:
```
createuser -r ed_materializer
```

4) Run this to setup:
```
bundle
rake db:create
rake db:migrate
```

5) Optional, pull down data from the “monster” prospecting spreadsheet:
```
rake import:spreadsheet
```

6) Start the rails server on port 3000:
```
rails s
```

Schema
------

Documented in the schema [wiki](https://github.com/gregmalcolm/ed-materializer/wiki/Schema)
