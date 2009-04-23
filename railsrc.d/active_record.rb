def db_inspect
  ActiveRecord::Base.connection.tables.sort.each do |table|
    count = ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM #{table}").to_i
    puts "%10s #{table}" % count
  end
  nil
end
