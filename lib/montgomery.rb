module Montgomery
  autoload :Collection, 'montgomery/collection'
  autoload :Connection, 'montgomery/connection'
  autoload :Database, 'montgomery/database'
  autoload :Silencer, 'montgomery/silencer'
end

Montgomery::Silencer.silently { require 'mongo' }
