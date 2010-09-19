# encoding: UTF-8

require 'pp'

$LOAD_PATH.unshift 'lib'
require 'montgomery'

class User
 include Montgomery::Entity

 attr_reader :email

 def places
   Places.find({user_id: @_id})
 end
end

class Place
 include Montgomery::Entity

 attr_accessor :name, :city, :district

 # someday some helpers might be added, like AR's belongs_to and has*
 def user
   Users.find_one({_id: @user_id})
 end

 def user=(user)
   @user_id = user._id
 end
end

# assign collections to class-looking constants
database = Montgomery::Connection.new.database('montgomery')
Users = database.collection('users')
Places = database.collection('places')

# clear the collections
Users.drop
Places.drop

# instantiate a user
user = User.new(email: 'wojciech@piekutowski.net', password: 'foobar')
pp user #=> a plain Ruby object, with @email=wojciech@piekutowski.net, @password=foobar and MongoDB's @_id
pp user.places #=> returns DB cursor
pp user.email #=> wojciech@piekutowski.net
#pp user.password #=> raises NoMethodError

# store the user in the DB
Users.insert user
pp user._id #=> MongoDB document id

pp Users.count #=> 1
pp user.places.to_a #=> []

# create some places
my_places = []
my_places << Place.new(name: 'ABC', user_id: user._id, city: 'Białystok', district: 'Centrum')
my_places << Place.new(name: 'Empik', user_id: user._id, city: 'Białystok', district: 'Śródmieście')
my_places << Place.new(name: 'Savona', user_id: user._id, city: 'Białystok', district: 'Śródmieście')
my_places.each { |place| Places.insert place }

pp user.places.to_a

place = Places.find_one
pp place
pp place.user
pp place.name

# find can return a DB cursor or accept the block which will provide a
# cursor and will close it when leaving the block (similar to File.open)
places_cursor = Places.find
Places.find do |places|
 pp places.to_a
end

# you can do aggregations
pp Places.group(['city', 'district'], {}, {count: 0}, 'function(doc,
result) { result.count++; }')

# it's possible to update place's info
place.name = "Kotłownia"
Places.save(place)
pp Places.find_one({name: "Kotłownia"})

# run collection-wide update
Places.update({city: "Białystok"}, {'$set' => {district: 'Śródmieście'}})
# to see the changes in Ruby-land I need to load the object again
pp Places.find_one({name: "Kotłownia"}) #=> district is now 'Śródmieście'
