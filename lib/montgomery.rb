module Montgomery
end

require 'montgomery/silencer'

Montgomery::Silencer.silently {
  require 'mongo'
  require 'delegate'
}

require 'montgomery/entity'
require 'montgomery/connection'
require 'montgomery/database'
require 'montgomery/collection'
require 'montgomery/cursor'
require 'montgomery/mapper'
