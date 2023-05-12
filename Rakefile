require 'pathname'

LINK_FILES = %w(irbrc irbrc.d pryrc railsrc railsrc.d aprc bash_profile bash_profile.d editrc inputrc ackrc gitignore)
INSERT_FILES = %w(gemrc gitconfig)

def stop_error(message)
  puts "ERROR: #{message}"
  exit(1)
end

def nice_symlink(target, link)
  target = File.expand_path(target)
  link   = File.expand_path(link)
  puts "Linking #{link} => #{target}"
  if File.exist?(link) && Pathname.new(link).realpath.to_s != Pathname.new(target).realpath.to_s
    stop_error("File exists: #{link}")
  elsif !File.exist?(link)
    File.symlink(target, link)
    puts
  end
end

desc "Install all dotfiles"
task :install do
  home = ENV['HOME']
  pwd = File.dirname(__FILE__)

  if `git symbolic-ref refs/remotes/origin/HEAD`.chomp != "refs/remotes/origin/main"
    puts "Correcting master -> main branch rename"

    exec("
      git branch --move master main &&
      git fetch origin &&
      git branch --set-upstream-to origin/main main &&
      git remote set-head origin --auto
    ") || abort
  end

  LINK_FILES.each do |file|
    nice_symlink("#{pwd}/#{file}", "#{home}/.#{file}")
  end

  INSERT_FILES.each do |file|
    insert = File.read("#{pwd}/#{file}").strip
    lines = insert.split("\n")

    matcher = Regexp.new(Regexp.escape(lines.first) + '.*?' + Regexp.escape(lines.last), Regexp::MULTILINE)

    contents = File.exists?("#{home}/.#{file}") ? File.read("#{home}/.#{file}") : ''

    puts "Insert content into #{home}/.#{file}"
    output =
      if contents =~ matcher
        contents.sub(matcher, insert)
      else
        puts "WARNING: This is the first time editing #{home}/.#{file} automatically, you should verify the contents."
        insert + "\n" + contents
      end

    File.open("#{home}/.#{file}", 'w') do |f|
      f.write(output)
    end
  end
end

task :default => :install
