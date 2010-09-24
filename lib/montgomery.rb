module Montgomery
  autoload :Collection, 'montgomery/collection'
  autoload :Connection, 'montgomery/connection'
  autoload :Cursor, 'montgomery/cursor'
  autoload :Database, 'montgomery/database'
  autoload :Delegator, 'montgomery/delegator'
  autoload :Entity, 'montgomery/entity'
  autoload :Mapper, 'montgomery/mapper'
  autoload :Silencer, 'montgomery/silencer'
end

Montgomery::Silencer.silently { require 'mongo' }
