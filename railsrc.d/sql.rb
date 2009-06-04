# From http://github.com/mislav/dotfiles/tree/master/railsrc

def sql(query)
  ActiveRecord::Base.connection.select_all(query)
end

def sql_bench(query, runs = 10)
  puts
  pp sql("EXPLAIN #{query}").first
  puts
  puts "#{runs} runs in"
  runs_time = Benchmark.realtime { runs.times { sql(query) } }
  puts "  #{runs_time}"
end