require 'rubygems'
require 'irb/completion'

# Use the simple prompt if possible.
IRB.conf[:PROMPT_MODE] = :SIMPLE if IRB.conf[:PROMPT_MODE] == :DEFAULT
