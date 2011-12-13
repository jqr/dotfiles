begin
  require 'ap'

  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
rescue LoadError
  # no awesome print for you
end
