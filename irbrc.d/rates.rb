# Watches a value change over time showing you current value and rate of
# change.
#
#   rate { Time.now.to_i }
#   # 1243457076 (0.999/sec) 
#   # 1243457077 (0.999/sec) 
#   # 1243457078 (0.999/sec) 
def rate(options = {})
  clear = `clear`
  defaults = {
    :delay => 1,
    :width => 5,
    :clear => true
  }
  options = defaults.merge(options)
  values = []
  loop do
    values << [yield, Time.now]
    values = values.last(options[:width])
    value_delta = values.last.first - values.first.first
    time_delta = values.last.last - values.first.last
    rate = (value_delta.to_f / time_delta)
    rate = 0 unless rate.finite?
    last_value = values.last.first
    print clear if options[:clear]
    time_to_zero = 
      if rate != 0 && last_value != 0 && (rate.abs / rate) != (last_value.abs / last_value)
        "%.3f hours" % (-last_value.to_f / rate / 60 / 60)
      end
    
    puts "%10i (%.3f/sec) #{time_to_zero}" % [last_value, rate]
    puts unless options[:clear]
    sleep options[:delay]
  end
end

# Watches a group of values change over time showing you current value and
# rate of change.
#
#   rates {{ :time => Time.now.to_i, :today => Date.today.to_time.to_i }}
#   # time: 1243457162 (0.997/sec) 
#   # today: 1243396800 (0.000/sec)
def rates(options = {})
  clear = `clear`
  defaults = {
    :delay => 1,
    :width => 5,
    :clear => true
  }
  options = defaults.merge(options)
  values = []
  loop do
    values << [yield, Time.now]
    values = values.last(options[:width])
    time_delta = values.last.last - values.first.last
    print clear if options[:clear]
    values.first.first.keys.sort { |a, b| a.to_s <=> b.to_s }.each do |key|
      value_delta = values.last.first[key] - values.first.first[key]
      rate = (value_delta.to_f / time_delta)
      rate = 0 unless rate.finite?
      last_value = values.last.first[key] 
      time_to_zero = 
        if rate != 0 && last_value != 0 && (rate.abs / rate) != (last_value.abs / last_value)
          "%.3f hours" % (-last_value.to_f / rate / 60 / 60)
        end

      puts "%20s: %9i (%.3f/sec) #{time_to_zero}" % [key, last_value, rate]
    end
    puts unless options[:clear]
    sleep options[:delay]
  end
end
