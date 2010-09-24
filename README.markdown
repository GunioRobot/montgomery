Montgomery
==========

A thin and lean object-document mapping layer for Ruby-MongoDB.

Montogomery is a very simplistic and thin layer over the existing Ruby MongoDB driver. It turns MongoDB into a kind of persistent object storage. Still the programmer has to decide when an object should be saved and what goes to the database. Montgomery tries to stay away from your plan Ruby classes as much as possible, contrary to some other ORMs out there. Because of that the source code is easy to follow and understand, so skilled Rubyist can adjust it to every project's needs.

Instead of polluting your objects and classes with a myriad of DB-related methods (like #save, .find, etc) we have here 2 kinds of objects: entities and collections. Please take a peek into /examples dir.

Features
--------

- full control over your domain models - you're responsible for the #initialize
- delare which attributes should be saved to the DB. you can also save
  calculated fields easily
- serialization/deserialization code is small and easy to grasp
- _id/id is set automatically

Installation
------------

Start with the mongo gem:

gem install mongo

Ruby 1.9.2 is currently supported. ATM there's no gem, so just clone the repo.

Usage
-----

`
$LOAD_PATH.unshift '/path_to_montgomery/lib'
require 'montgomery'
`

Examples
--------

Please take a look in /example directory and /spec. Note: examples require a running MongoDB.
