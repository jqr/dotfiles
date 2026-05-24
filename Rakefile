require 'pathname'

LINK_FILES = %w(irbrc irbrc.d pryrc railsrc railsrc.d bash_profile bashrc bash_profile.d zshrc editrc inputrc gitignore gitattributes)
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
  end
end

desc "Install all dotfiles"
task :install do
  home = ENV['HOME']
  Dir.chdir(File.dirname(__FILE__))

  if `git symbolic-ref refs/remotes/origin/HEAD`.chomp != "refs/remotes/origin/main"
    puts "Correcting master -> main branch rename"

    exec("
      git branch --move master main &&
      git fetch origin &&
      git branch --set-upstream-to origin/main main &&
      git remote set-head origin --auto
    ") || abort
  end

  dotfiles_dir = File.expand_path('.')
  Dir.glob("#{home}/.*").each do |link|
    next unless File.symlink?(link)
    target = File.readlink(link)
    target = File.expand_path(target, File.dirname(link))
    next unless target.start_with?(dotfiles_dir + '/')
    name = File.basename(link).sub(/^\./, '')
    unless LINK_FILES.include?(name)
      puts "Removing stale symlink #{link}"
      File.delete(link)
    end
  end

  LINK_FILES.each do |file|
    nice_symlink(file, "#{home}/.#{file}")
  end

  INSERT_FILES.each do |file|
    insert = File.read(file).strip
    start_marker = insert.split("\n").first
    end_marker = insert.split("\n").last

    existing = File.exist?("#{home}/.#{file}") ? File.readlines("#{home}/.#{file}") : []

    puts "Insert content into #{home}/.#{file}"
    before, after = [], []
    target = before
    found = false
    existing.each do |line|
      if line.strip == start_marker
        found = true
        target = nil
      elsif target.nil? && line.strip == end_marker
        target = after
      elsif target
        target << line
      end
    end

    unless found
      puts "WARNING: This is the first time editing #{home}/.#{file} automatically, you should verify the contents."
    end

    output = (before.map(&:chomp) + [insert] + after.map(&:chomp)).join("\n") + "\n"

    tmpfile = "#{home}/.#{file}.tmp"
    File.write(tmpfile, output)
    File.rename(tmpfile, "#{home}/.#{file}")
  end
end

task :default => :install
