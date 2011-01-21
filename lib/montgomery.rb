require 'montgomery/silencer'

Montgomery::Silencer.silently { require 'mongo' }

require 'montgomery/delegator'
require 'montgomery/connection'
require 'montgomery/database'
require 'montgomery/collection'
require 'montgomery/cursor'
require 'montgomery/entity'
require 'montgomery/mapper'
