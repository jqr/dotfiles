# From http://github.com/mislav/dotfiles/tree/master/railsrc

def sql(query)
  ActiveRecord::Base.connection.select_all(query)
end

def sql_bench(query, runs = 10)
  puts
  puts sql("EXPLAIN ANALYZE VERBOSE #{query}").map(&:values).flatten.join("\n")
  puts
  puts "#{runs} runs in"
  runs_time = Benchmark.realtime { runs.times { sql(query) } }
  puts "  #{runs_time}"
end