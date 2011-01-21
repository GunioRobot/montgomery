# encoding: UTF-8

require 'pp'

$LOAD_PATH.unshift 'lib'
require 'montgomery'

class User
  # This class can be saved to the database. #id, #_id and #id=, #_id= will be
  # added to handle BSON::ObjectId. #_id= is called after #initialize is done.
  include Montgomery::Entity

  # Add an #email method (similar to attr_reader) and tell Montgomery
  # that it should save the return value of #email to the database
  montgomery_attr_reader :email
  montgomery_attr_reader :full_name, :password
  # Add #role and #role= (like attr_accessor) and save the return value of role
  # to the database
  montgomery_attr_accessor :role
  montgomery_attr_accessor :first_name, :last_name

  # Initialize must accept a hash (a MongoDB doc). It's up to you to
  # setup your object. There's no need to setup @_id, it will be done after
  # #initialize returns. However you can find it in values['_id'] if you need
  # it here.
  def initialize(values={})
    @email = values['email']
    @password = values['password']
    @role = values['role']
    @first_name = values['first_name']
    @last_name = values['last_name']
  end

  # Plain Ruby method. It's output will be saved to the DB - you can query by
  # full_name later. It might by a good idea to index such field.
  def full_name
    "#{first_name} #{last_name}"
  end

  def places
    Places.find({user_id: id})
  end
end

class Place
  include Montgomery::Entity

  montgomery_attr_accessor :name
  montgomery_attr_reader :city, :district, :user_id

  def initialize(values={})
    @name = values['name']
    @city = values['city']
    @district = values['district']
    if values.has_key?('user_id')
      @user_id = values['user_id']
    elsif values.has_key?('user')
      self.user = values['user']
    end
  end

  # Someday some helpers might be added, like AR's belongs_to and has*
  def user
    Users.find_one({id: @user_id})
  end

  def user=(user)
    @user_id = user.id
  end
end

puts "Connecting..."
# assign collections to class-like constants
database = Montgomery::Connection.new.database('montgomery')
Users = database.collection('users')
Places = database.collection('places')

puts "Droping collections..."
# clear the collections
Users.drop
Places.drop

puts "Creating a new user..."
user = User.new 'email' => 'wojciech@piekutowski.net',
  'password' => 'foobar',
  'first_name' => 'Wojciech',
  'last_name' => 'Piekutowski'
puts "User:"
pp user #=> a plain Ruby object, with @email=wojciech@piekutowski.net, @password=foobar and MongoDB's @_id
puts "User's places cursor:"
pp user.places #=> returns DB cursor
puts "User's email:"
pp user.email #=> wojciech@piekutowski.net
#pp user.password #=> raises NoMethodError

puts "Inserting user..."
Users.insert user
puts "User id:"
pp user.id #=> MongoDB document id

puts "Users count:"
pp Users.count #=> 1
puts "User's places:"
pp user.places.to_a #=> []
puts "Users:"
pp Users.find.to_a #=> [#<User...>]

puts "Creating places..."
my_places = []
my_places << Place.new('name' => 'ABC', 'user' => user, 'city' => 'Białystok', 'district' => 'Centrum')
my_places << Place.new('name' => 'Empik', 'user' => user, 'city' => 'Białystok', 'district' => 'Śródmieście')
my_places << Place.new('name' => 'Savona', 'user' => user, 'city' => 'Białystok', 'district' => 'Śródmieście')
my_places.each { |place| Places.insert place }

puts "User's places:"
pp user.places.to_a

place = Places.find_one
puts "Place:"
pp place
puts "Place's user:"
pp place.user
puts "Place's name:"
pp place.name

# find can return a DB cursor or accept the block which will provide a
# cursor and will close it when leaving the block (similar to File.open)
places_cursor = Places.find
Places.find do |places|
  puts "Places:"
  pp places.to_a
end

# you can do aggregations
puts "Group places by city and district:"
pp Places.group key: ['city', 'district'],
                initial: {count: 0},
                reduce: 'function(doc, result) { result.count++; }'

# it's possible to update place's info
puts "Updating place with name 'Kotłownia'..."
place.name = "Kotłownia"
Places.save(place)
puts "Updated place:"
pp Places.find_one({name: "Kotłownia"})

# run collection-wide update
puts "Updating places with {'$set' => {district: 'Śródmieście'}}..."
Places.update({city: "Białystok"}, {'$set' => {district: 'Śródmieście'}}, multi: true)

# to see the changes in Ruby-land you need to load the object again
puts "One of the updated places:"
pp Places.find_one({name: "Kotłownia"}) #=> district is now 'Śródmieście'

puts "User's places:"
pp user.places.to_a

puts "Creating a new user..."
user2 = User.new 'email' => 'john@example.com',
  'password' => 'barbaz',
  'first_name' => 'John',
  'last_name' => 'Doe'

puts "...and saving him..."
Users.save(user2)

puts "User found by full_name:"
pp user2 = Users.find_one({full_name: 'John Doe'})
puts "User's full name:"
pp user2.full_name
