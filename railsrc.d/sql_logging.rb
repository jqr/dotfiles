# From http://github.com/ryanb/dotfiles/tree/master/railsrc
require 'active_record'

def active_record_log(stream)
  ActiveRecord::Base.logger = Logger.new(stream)
  if ActiveRecord::Base.respond_to?(:clear_all_connections!)
    ActiveRecord::Base.clear_all_connections!
  else
    ActiveRecord::Base.clear_all_connections
  end
  nil
end

def sql_on
  active_record_log(STDOUT)
end

def sql_off
  active_record_log(nil)
end

# sql_on
