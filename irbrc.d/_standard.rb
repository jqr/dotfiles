require 'rubygems'
require 'irb/completion'

# Use the simple prompt if possible.
if IRB.respond_to?(:conf)
  IRB.conf[:PROMPT_MODE] = :SIMPLE if IRB.conf[:PROMPT_MODE] == :DEFAULT
end
