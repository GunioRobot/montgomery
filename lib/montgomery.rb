require 'montgomery/silencer'

Montgomery::Silencer.silently {
  require 'mongo'
  require 'delegate'
}

require 'montgomery/connection'
require 'montgomery/database'
require 'montgomery/collection'
require 'montgomery/cursor'
require 'montgomery/entity'
require 'montgomery/mapper'
