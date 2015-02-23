# lol-stats
League Of Legends Statistic Frontends

## Synopsis

This is a small web application to work with 
the game api from riot games.

## Motivation

It's just for fun and I'm just playing around

## Configuration

Create a secrets.rb and set your API key.

```bash
$ cp config/initializers/secrets.rb.sample config/initializers/secrets.rb
$ vi config/initializers/secrets.rb
```

If you don't have an api key get one on https://developer.riotgames.com

## Installation

```
$ bundle install
$ rake db:migration
$ rails server
```A

## Tests

tbd

## Authors

**Mike Liebsch**

## Copyright and license

Code released under [the MIT license](LICENSE).
The included bootstrap has a copyright by Twitter Inc, but is also released under the MIT license

