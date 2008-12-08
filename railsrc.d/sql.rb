# From http://github.com/mislav/dotfiles/tree/master/railsrc

def sql(query)
  ActiveRecord::Base.connection.select_all(query)
end