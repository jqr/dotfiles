def require_rb_files_from(dir)
  Dir.glob(File.join(dir, '*.rb')) do |file|
    require file
  end
end

require_rb_files_from(File.join(ENV['HOME'], '.irbrc.d'))

load File.join(ENV['HOME'], '.railsrc') if $0 == 'irb' && ENV['RAILS_ENV']