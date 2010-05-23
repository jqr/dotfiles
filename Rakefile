def stop_error(message)
  puts "ERROR: #{message}"
  exit(1)
end

def symlink(target, link)
  puts "Linking #{link} => #{target}"
  if File.symlink?(link)
    puts "  * deleting existing symlink #{link}"
    File.unlink(link)
  elsif File.exist?(link)
    stop_error("File exists: #{link}")
  end
  File.symlink(target, link)
  puts
end

desc "Install all dotfiles"
task :install do
  home = ENV['HOME']
  pwd = File.dirname(__FILE__)

  %w(irbrc irbrc.d railsrc railsrc.d bash_profile bash_profile.d editrc inputrc ackrc).each do |file|
    symlink("#{pwd}/#{file}", "#{home}/.#{file}")
  end
  
  %w(gemrc).each do |file|
    insert = File.read("#{pwd}/#{file}").strip
    lines = insert.split("\n")

    matcher = Regexp.new(Regexp.escape(lines.first) + '.*?' + Regexp.escape(lines.last), Regexp::MULTILINE)

    contents = File.read("#{home}/.#{file}")

    output = 
      if contents =~ matcher
        contents.sub(matcher, insert)
      else
        puts "WARNING: inserted content into #{file} since there was no existing region, you should verify the contents."
        insert + "\n" + contents
      end
    
    File.open("#{home}/.#{file}", 'w') do |f|
      f.write(output)
    end
  end
end